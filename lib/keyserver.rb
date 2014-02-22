class Keyserver
  
  require 'net/http'

  def self.get_keyid_by_email(email)
    result = self.request_user_by_email(email)    
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
  
  def self.request_user_by_email(email)
    Net::HTTP.get(URI.parse("#{APP_CONFIG['keyserver']}/pks/lookup?op=vindex&search=#{email}&exact=on&options=mr"))
  end
  
  def self.request_user_by_keyid(keyid)
    Net::HTTP.get(URI.parse("#{APP_CONFIG['keyserver']}/pks/lookup?op=vindex&search=#{keyid}&fingerprint=on&options=mr"))
  end
  
  def self.request_key_by_user(user)
    Net::HTTP.get(URI.parse("#{APP_CONFIG['keyserver']}/pks/lookup?op=get&search=#{user}&options=mr"))
  end
  
end