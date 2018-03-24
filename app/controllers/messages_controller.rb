class MessagesController < ApplicationController
  before_filter :set_locale

  require './lib/keyserver.rb' 
  require './lib/util.rb' 
  require 'digest/md5'

  # GET /messages/new
  def new
    @message = Message.new
    @uid = params[:uid]
    @uid.downcase! if @uid    
    if @uid
      # get local user  
      @user = User.where("lower(username) = ?", @uid.downcase).first 
      if @user
        # local user
        @pubkey = @user.public_key
        @to = @uid        
      else
        # remote user
        if Util.is_email?(@uid)
           # email
           begin
             @keyids = Keyserver.get_keyids_by_email(@uid)             
             @to = @uid
           rescue
             # key not found
           end         
        elsif @uid.include?("0x")
           # keyid
           begin
             result = Keyserver.get_users_by_keyid(@uid)
             @to = Util.get_emails(result)
             @keyids = [@uid]
           rescue
             # key not found
           end
        end   
        begin 
          @pubkey = Keyserver.get_publickey_by_keyid(@keyids.first) if @keyids
        rescue
          # key not found
        end
      end
    end
    # render
    respond_to do |format|
      if @pubkey && @pubkey.include?("BEGIN PGP PUBLIC KEY BLOCK")
        format.html
      elsif @uid && @uid.include?("0x")
        format.html { redirect_to "/", notice: t("messages.new.no_mail") }
      elsif @uid && @uid.include?("@")
        format.html { redirect_to "/", notice: t("messages.new.no_public_key") }
      else
        format.html { redirect_to "/", notice: t("messages.new.invalid_link") }
      end  
    end
  end

  # POST /messages
  def create
    # get params
    to = params[:message][:to]
    from = params[:message][:from]
    body = params[:message][:body]
    file = params[:message][:file].blank? ? nil : params[:message][:file]
    filename = params[:message][:filename].blank? ? nil : params[:message][:filename]
    # local user
    user = User.where("lower(username) = ?", to.downcase).first
    to = user.email if user
    # protect spam
    tohash = Digest::MD5.hexdigest(to)
    fromhash = Digest::MD5.hexdigest(from)
    spam = Message.where("created_at > ? and tohash = ?", DateTime.now - 5.minutes, tohash)
    # render    
    respond_to do |format|
      if spam.size >= 5
        format.html { redirect_to "/", notice: 'Spam? Please wait 5 minutes!' }
      elsif Util.is_email?(to) and Util.is_email?(from) and spam.size <= 5 and body.include?("BEGIN PGP MESSAGE") and body.include?("END PGP MESSAGE")
        Message.create!(:tohash => tohash, :fromhash => fromhash) # ignore message body
        MessageMailer.send_message(to, from, body, :file => file, :filename => filename).deliver_now
        username = user.username.downcase if user
        MessageMailer.thanks_message(to, from, username).deliver_now
        if user
          format.html { redirect_to "/#{user.username}/thanks" }
        else
          format.html { redirect_to "/", notice: t(".success_send") }
        end
      else
        format.html { redirect_to "/", notice: t(".error_send") }
      end
    end
  end
  
  private
  def set_locale
    I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
  end
  
  def message_params
    params.require(:message).permit(:tohash, :fromhash, :keyid)
  end
end
