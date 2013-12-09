class MessageMailer < ActionMailer::Base
  include AbstractController::Callbacks
  
  default from: "Encrypt.to <mail@encrypt.to>"
  
  after_filter :delete_body
  
  def send_message(message)
    @message = message
    subject = message.from + " has sent you an encrypted mail"
    mail(to: message.to, reply_to: message.from, subject: subject, :body => message.body)
  end
  
  def thanks_message(message)
    subject = "Thanks for using Encrypt.to"
    @to = message.to
    mail(to: message.from, subject: subject)
  end
  
  private  
  def delete_body
    if @message
      @message.body = Time.now.to_s
      @message.save
    end
  end

end
