class ApplicationController < ActionController::Base
  protect_from_forgery

  def is_email?(email)
    !email.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i).empty?
  end

  def get_emails(str)
    str.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i)
  end
  
  def get_keyid(result, email)
     id = []
     list = []
     uids = []
     result.each_line do |line|
       uids << line
     end
     uids.reverse!
     for uid in uids
     	id << uid.split(":")[1] if uid.include?("uid")
       if uid.include?("pub")
         id << uid.split(":")[1] 
         list << id
         id = []
       end	
     end
     found = list.select{|x|x.join.include?(email)}
     return "0x#{found[0].last}"
  end  
end