class Keyserver
  
  require 'net/http'

  def self.get_keyids_by_email(email)
    result = self.get_users_by_email(email)
    return if result.nil?  
    modified_string = result.gsub(/\s+/, '').strip
    uids = modified_string.split("pub:")
    found = []
    for uid in uids
      found << "0x" + uid.split(":")[0].downcase if uid.downcase.include?(email)
    end
    found
  end
  
  def self.get_users_by_email(email)
    resp = Net::HTTP.get(URI.parse("#{APP_CONFIG['keyserver']}/pks/lookup?op=vindex&search=#{email}&exact=on&options=mr"))
    self.key_is_valid(resp) ? resp : nil
  end
  
  def self.get_users_by_keyid(keyid)
    resp = Net::HTTP.get(URI.parse("#{APP_CONFIG['keyserver']}/pks/lookup?op=vindex&search=#{keyid}&fingerprint=on&options=mr"))
    self.key_is_valid(resp) ? resp : nil
  end
  
  def self.get_publickey_by_keyid(user)
    Net::HTTP.get(URI.parse("#{APP_CONFIG['keyserver']}/pks/lookup?op=get&search=#{user}&options=mr"))
  end
  
  def self.key_is_valid(key)
    revoke = key.split("pub:")[1].split("uid:")[0]
    return false if revoke[revoke.size - 2] == "r"
    exp = revoke.split(":")[4].to_i
    exp == 0 ? true : Time.now < Time.at(exp)
  end

end