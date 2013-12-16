class MessageMailer < ActionMailer::Base
  include AbstractController::Callbacks
  
  default from: APP_CONFIG['sender']
  
  def send_message(to, from, body)
    subject = "#{from} has sent you an encrypted mail"
    mail(to: to, reply_to: from, subject: subject, :body => body)
  end
  
  def thanks_message(to, from)
    subject = "Thanks for using Encrypt.to"
    @to = to
    mail(to: from, subject: subject)
  end
    
end
