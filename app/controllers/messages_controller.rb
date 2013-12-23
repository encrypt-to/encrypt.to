class MessagesController < ApplicationController

  require 'open-uri'
  require 'digest/md5'

  # GET /messages/new
  def new
    @message = Message.new
    @uid = params[:uid]
    # get local user  
    user = User.find_by_username(@uid)    
    if user
      @pubkey = user.public_key
      @to = @uid      
    else
      if is_email?(@uid)
         # email
         begin       
           result = open("#{APP_CONFIG['keyserver']}/pks/lookup?op=vindex&search=#{@uid}&exact=on&options=mr").read
           @keyid = get_keyid(result, @uid)
           @to = @uid
         rescue
           # key not found
         end         
      elsif @uid.include?("0x")
         # keyid
         begin
           result = open("#{APP_CONFIG['keyserver']}/pks/lookup?op=vindex&search=#{@uid}&fingerprint=on&options=mr").read
           @to = get_emails(result)
           @keyid = @uid
         rescue
           # key not found
         end
      end   
      begin 
        @pubkey = open("#{APP_CONFIG['keyserver']}/pks/lookup?op=get&search=#{@keyid}&options=mr").read if @keyid
      rescue
        # key not found
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
