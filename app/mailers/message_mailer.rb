class MessageMailer < ActionMailer::Base
  include AbstractController::Callbacks
  
  default from: APP_CONFIG['sender']
  
  def send_message(to, from, body, *args)
    opts = args.extract_options!
    file = opts[:file] ||= false
    filename = opts[:filename] ||= false
    if file and filename
      attachments[filename] = {:mime_type => 'application/x-gzip', :content => Base64.decode64(file)}
    end
    subject = "#{from} has sent you an encrypted mail"
    mail(to: to, reply_to: from, subject: subject, :body => body)
  end
  
  def thanks_message(to, from, username = nil)
    subject = "Thanks for using Encrypt.to"
    @to = username.nil? ? to : username
    mail(to: from, subject: subject)
  end
    
end
