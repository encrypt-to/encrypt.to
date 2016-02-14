class Util
  
  def self.is_email?(email)
    !email.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,8}\b/i).empty?
  end

  def self.get_emails(str)
    str.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,8}\b/i)
  end
  
end
