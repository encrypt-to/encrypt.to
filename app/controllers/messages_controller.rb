class MessagesController < ApplicationController

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
      @user = User.find(:first, :conditions => [ "lower(username) = ?", @uid.downcase ]) 
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
      if @to && @to.empty?
        format.html { redirect_to "/", notice: "Sorry, this key-id has no associated email address." }
      elsif @pubkey && @pubkey.include?("BEGIN PGP PUBLIC KEY BLOCK")
        format.html
      else
        format.html { redirect_to "/", notice: "Sorry no user with this email or key-id exists. Try again!" }
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
    user = User.find(:first, :conditions => [ "lower(username) = ?", to.downcase ]) 
    to = user.email if user
    # protect spam
    tohash = Digest::MD5.hexdigest(to)
    fromhash = Digest::MD5.hexdigest(from)
    spam = Message.find(:all, :conditions => ["created_at > ? and tohash = ?", DateTime.now - 5.minutes, tohash])
    # render    
    respond_to do |format|
      if spam.size >= 5
        format.html { redirect_to "/", notice: 'Spam? Please wait 5 minutes!' }
      elsif Util.is_email?(to) and Util.is_email?(from) and spam.size <= 5 and body.include?("BEGIN PGP MESSAGE") and body.include?("END PGP MESSAGE")
        Message.create!(:tohash => tohash, :fromhash => fromhash) # ignore message body
        MessageMailer.send_message(to, from, body, :file => file, :filename => filename).deliver
        username = user.username.downcase if user
        MessageMailer.thanks_message(to, from, username).deliver
        if user
          format.html { redirect_to "/#{user.username}/thanks" }
        else
          format.html { redirect_to "/", notice: 'Encrypted message sent! Thanks.' }
        end
      else
        format.html { redirect_to "/", notice: 'Sorry something went wrong. Try again!' }
      end
    end
  end

end
