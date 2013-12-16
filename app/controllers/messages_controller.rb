class MessagesController < ApplicationController

  require 'open-uri'

  # GET /messages/new
  def new
    @message = Message.new
    @to = params[:email]
    @pubkey = open("#{APP_CONFIG['keyserver']}/pks/lookup?op=get&search=#{@to}&options=mr").read
    
    respond_to do |format|
      if @pubkey.include?("BEGIN PGP PUBLIC KEY BLOCK") and (is_email?(@to) or @to.include?("0x"))
        format.html
      else
        format.html { redirect_to "/" }
      end  
    end
  end

  # POST /messages
  def create
    to = params[:message][:to]
    from = params[:message][:from]
    body = params[:message][:body]

    if !is_email?(to)
      result = open("#{APP_CONFIG['keyserver']}/pks/lookup?op=vindex&search=#{params[:message][:to]}&fingerprint=on&options=mr").read
      to = get_email(result)
    end
    
    Message.create! # to, from and boy will not be saved, just for stats
    
    respond_to do |format|
      if is_email?(to) and is_email?(from)
        MessageMailer.send_message(to, from, body).deliver
        MessageMailer.thanks_message(to, from).deliver
        format.html { redirect_to "/", notice: 'Encrypted message sent! Thanks.' }
      else
        format.html { redirect_to "/", notice: 'Sorry something went wrong. Try again!' }
      end
    end
  end

end
