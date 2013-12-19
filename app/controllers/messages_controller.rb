class MessagesController < ApplicationController

  require 'open-uri'
  require 'digest/md5'

  # GET /messages/new
  def new
    @message = Message.new
    @to = params[:email]
    @pubkey = open("#{APP_CONFIG['keyserver']}/pks/lookup?op=get&search=#{@to}&options=mr").read
    
    respond_to do |format|
      if @pubkey.include?("BEGIN PGP PUBLIC KEY BLOCK") and is_email?(@to)
        format.html
      elsif @to.include?("0x")
        format.html { redirect_to "/", notice: "Sorry you can't use a key-id, instead use an email address. Try again!"  }
      else
        format.html { redirect_to "/", notice: "Sorry we can't find the email on a public key server. Try again!"  }
      end  
    end
  end

  # POST /messages
  def create
    to = params[:message][:to]
    from = params[:message][:from]
    body = params[:message][:body]

    # protect spam
    tohash = Digest::MD5.hexdigest(to)
    fromhash = Digest::MD5.hexdigest(from)
    spam = Message.find(:all, :conditions => ["created_at >= ? and tohash == ?", DateTime.now - 5.minutes, tohash])
    
    respond_to do |format|
      if spam.size >= 5
        format.html { redirect_to "/", notice: 'Spam? Please wait 5 minutes!' }
      elsif is_email?(to) and is_email?(from) and spam.size <= 5
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
