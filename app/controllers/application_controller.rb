class ApplicationController < ActionController::Base
  protect_from_forgery

  def is_email?(email)
    !email.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i).empty?
  end

  def get_emails(str)
    str.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i)
  end
  
  def get_keyid(result, email)
    modified_string = result.gsub(/\s+/, '').strip
    uids = modified_string.split("pub:")
    for uid in uids
      if uid.include?(email)
        found = uid.split(":")[0]
        break
      end
    end
    return "0x#{found}"
  end  
end
