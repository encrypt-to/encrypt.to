class Keyserver
  
  require 'net/http'

  def self.get_keyids_by_email(email)
    result = self.get_users_by_email(email)    
    modified_string = result.gsub(/\s+/, '').strip
    uids = modified_string.split("pub:")
    found = []
    for uid in uids
      if uid.include?(email)
        found << "0x" + uid.split(":")[0]
      end
    end
    return found
  end
  
  def self.get_users_by_email(email)
    Net::HTTP.get(URI.parse("#{APP_CONFIG['keyserver']}/pks/lookup?op=vindex&search=#{email}&exact=on&options=mr"))
  end
  
  def self.get_users_by_keyid(keyid)
    Net::HTTP.get(URI.parse("#{APP_CONFIG['keyserver']}/pks/lookup?op=vindex&search=#{keyid}&fingerprint=on&options=mr"))
  end
  
  def self.get_publickey_by_keyid(user)
    Net::HTTP.get(URI.parse("#{APP_CONFIG['keyserver']}/pks/lookup?op=get&search=#{user}&options=mr"))
  end
  
end