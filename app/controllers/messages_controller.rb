class MessagesController < ApplicationController

  require 'net/http'
  require 'digest/md5'

  # GET /messages/new
  def new
    @message = Message.new
    @uid = params[:uid]
    if @uid
      # get local user  
      user = User.find(:first, :conditions => [ "lower(username) = ?", @uid.downcase ]) 
      if user
        # local user
        @pubkey = user.public_key
        @to = @uid
      else
        # remote user
        if is_email?(@uid)
           # email
           begin       
             result = Net::HTTP.get(URI.parse("#{APP_CONFIG['keyserver']}/pks/lookup?op=vindex&search=#{@uid}&exact=on&options=mr"))
             @keyid = get_keyid(result, @uid)
             @to = @uid
           rescue
             # key not found
           end         
        elsif @uid.include?("0x")
           # keyid
           begin
             result = Net::HTTP.get(URI.parse("#{APP_CONFIG['keyserver']}/pks/lookup?op=vindex&search=#{@uid}&fingerprint=on&options=mr"))
             @to = get_emails(result)
             @keyid = @uid
           rescue
             # key not found
           end
        end   
        begin 
          @pubkey = Net::HTTP.get(URI.parse("#{APP_CONFIG['keyserver']}/pks/lookup?op=get&search=#{@keyid}&options=mr")) if @keyid
        rescue
          # key not found
        end
      end
    end
    # render
    respond_to do |format|
      if @pubkey && @pubkey.include?("BEGIN PGP PUBLIC KEY BLOCK")
        format.html
      else
        format.html { redirect_to "/", notice: "Sorry we can't find the user. Try again!" }
      end  
    end
  end

  # POST /messages
  def create
    # get params
    to = params[:message][:to]
    from = params[:message][:from]
    body = params[:message][:body]
    # local user
    user = User.find_by_username(to)   
    to = user.email if user
    # protect spam
    tohash = Digest::MD5.hexdigest(to)
    fromhash = Digest::MD5.hexdigest(from)
    spam = Message.find(:all, :conditions => ["created_at >= ? and tohash == ?", DateTime.now - 5.minutes, tohash])
    # render    
    respond_to do |format|
      if spam.size >= 5
        format.html { redirect_to "/", notice: 'Spam? Please wait 5 minutes!' }
      elsif is_email?(to) and is_email?(from) and spam.size <= 5 and body.include?("BEGIN PGP MESSAGE") and body.include?("END PGP MESSAGE")
        Message.create!(:tohash => tohash, :fromhash => fromhash) # ignore message body
        MessageMailer.send_message(to, from, body).deliver
        MessageMailer.thanks_message(to, from).deliver
        format.html { redirect_to "/", notice: 'Encrypted message sent! Thanks.' }
      else
        format.html { redirect_to "/", notice: 'Sorry something went wrong. Try again!' }
      end
    end
  end

end
