require "rails_helper"

public_key = "-----BEGIN PGP PUBLIC KEY BLOCK-----\\nVersion: SKS 1.1.4\\nComment: Hostname: pgpkey.org\\n\\nmQENBFKyxokBCADIWV1KBbDnvGapdNIM2CSQjDnjfkVyvCGAhcyjlnlmLT23q61OPJasS+DE\\nA0ujZtsPa2aGZK3o8ETSgwTREXxeG3n7tlTyXrqkTN/rh00YY/CIubmkeIKQfPDaLD2UDqGL\\nn7gwFeSCtrfPkXFZsVN1GwiW3QsQfGH/c2CMt/t1BKu4RH5ZlLWSKifRPIFUK4gUEQ8SuwwV\\nLhlqHLStVwEnEvilwiQIKeI3HQvJM3LecGwOflDHbl/pwbXlODidkPGIv9AzqaFjGqtHs9eH\\nwcwflnncFJh8ey12LHPxaRUafExN/PMZZXbQFkSxd4rjXnHGFM0F9L6RZ/djMN17ihEDABEB\\nAAG0HUVuY3J5cHQudG8gPGhlbGxvQGVuY3J5cHQudG8+iQE9BBMBCgAnBQJSssaJAhsDBQkH\\nhh+ABQsJCAcDBRUKCQgLBRYCAwEAAh4BAheAAAoJEAyvHlsRSJofLJYIAKLSxtnTcqytoLES\\n1mkmfXGd3N4IsVzpM1J/M3+fvk1YY6JF5SAYYgAhEiO/cqRHVdRCbhIbzRwxNYIdc37sAopx\\ndq3xlrflon4lKPogp/07cFgTgyzFYrcWKaQ+1MX+LLRp0eqgGCaBMT6BLSCW69pfhGIbUg9Q\\nv9PJVSRNcTU+TO6698kiKGCleYmAldqYLjbzmJdgDawiKfWlyf4aJTh/gRDL6mD/K17nppsa\\n64PmJGccCQN7f00O2TSAwW7gZcJU+5djJetC0Y8PoPLBdXWH+pvsrxZcMjpTzA3RG5+O/naf\\nr7M8JSCWE988XYw5z9YY4A4/LYPQmBQNA55WUCm5AQ0EUrLGiQEIALIGx1feux9O/r+8tPJm\\nbS8x/8v+zWg7Y1Db5QRuPbWJbfqquWGyjeYMywgpFFyQrtO6sS8qz3dfufh2QCx1/6Tko+C+\\ndMgPWy+W2KwQl2zwK4DTsE//rXAQrpQslRFvT7SwiQMj7gi/1CCz8y9gPn4GRbUfOkGobty6\\nbxE7lK+5PziQ1IqFixW/pBby4MezfNS3CecaSPG0OBfwMAkrzjX8XYqZT0RXEwGqqsbHomJ4\\n5ZD1DO1lbQUCLa8BxaZjNvyoLIGHWxXlHz8UqpwpWutIRF2J02R6YbTrBz0mGlzxlnyI1OzC\\n43VypPhknJVRC8CEFGyF3ohQt8r3QmpNe8sAEQEAAYkBJQQYAQoADwUCUrLGiQIbDAUJB4Yf\\ngAAKCRAMrx5bEUiaH3JFB/sH+EDJJHw0WpSHG/of73/k6D7abKoyRt2Q0JJEoQEJnSyBQFiS\\nBFcS2GacUToXzbLksky27QLGThpGma78+9GHABIkf8dsJnPobOI3FMpWEmK9swURsD2r6aII\\nOhkeQYZE77D7BqGllVORcb4m+Tkst6VeDsIsAoIuFG8LGNT6it/Fptwcx3AtilFICKV55RxC\\nD+ziUtQAc64747QKjIJab/Gtz1vEOTiK3zty8R9SPKIQyfTNg7eCHtCBrKWQGiXBKv//lUKp\\n3R+OR/PgB1AMNUXxREhg7eV4ehM33oP08jCmByN1D7xbuql1t1N9xpggqSKl5oHmMZoNjeJm\\nF6rn\\n=mMV8\\n-----END PGP PUBLIC KEY BLOCK-----\\r\\n"
email = "hello@encrypt.to"
expired_email = "expired@encrypt.to"
unknown_email = "unknown@encrypt.to"
revoked_email = "revoked@encrypt.to"
upcase_email = "HELLO@ENCRYPT.TO"
encoding_email = "hello@encrypt.to"
short_keyid = "0x11489a1f"
long_keyid = "0x0caf1e5b11489a1f"
vindex_response = "info:1:2\npub:11489A1F:1:2048:1387447945::\nuid:Encrypt.to <hello@encrypt.to>:1387447945::\n\r\n"
vindex_response_expired = "info:1:2\npub:11489A1F:1:2048:1387447945:1287447945:\nuid:Encrypt.to <expired@encrypt.to>:1387447945:1287447945:\n\r\n"
vindex_response_unknown = "info:1:2\npub:11489A1F:1:2048:1387447945::\nuid:Encrypt.to <unknown@encrypt.to>:1387447945::\n\r\n"
vindex_response_revoked = "info:1:2\npub:11489A1F:1:2048:1387447945::\nuid:Encrypt.to <revoked@encrypt.to>:1387447945::r\n\r\n"
vindex_response_upcase = "info:1:2\npub:11489A1F:1:2048:1387447945::\nuid:Encrypt.to <HELLO@ENCRYPT.TO>:1387447945::\n\r\n"
vindex_response_encoding = "info:1:2\npub:11489A1F:1:2048:1387447945::\nuid:Encrypt.to%C3%A <hello@encrypt.to>:1387447945::\n\r\n"

keyserver_url = "http://pgpkey.org/pks/lookup"
error_msg = "Wrong params, please try again."
host = "http://localhost:3000/"

describe "/api/v1/keyserver/lookup", type: :request do
  
  let(:user) { create :info}

  before {
    stub_request(:get, keyserver_url + "?exact=on&op=vindex&options=mr&search=#{email}").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => vindex_response, :headers => {})
    stub_request(:get, keyserver_url + "?exact=on&op=vindex&options=mr&search=#{expired_email}").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => vindex_response_expired, :headers => {})
    stub_request(:get, keyserver_url + "?exact=on&op=vindex&options=mr&search=#{unknown_email}").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => vindex_response_unknown, :headers => {})
    stub_request(:get, keyserver_url + "?exact=on&op=vindex&options=mr&search=#{revoked_email}").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => vindex_response_revoked, :headers => {})
    stub_request(:get, keyserver_url + "?exact=on&op=vindex&options=mr&search=#{upcase_email}").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => vindex_response_upcase, :headers => {})
    stub_request(:get, keyserver_url + "?exact=on&op=vindex&options=mr&search=#{encoding_email}").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => vindex_response_encoding, :headers => {})
    stub_request(:get, keyserver_url + "?op=get&options=mr&search=#{short_keyid}").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => user.public_key, :headers => {})
    stub_request(:get, keyserver_url + "?fingerprint=on&op=vindex&options=mr&search=#{short_keyid}").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => vindex_response, :headers => {})
    stub_request(:get, keyserver_url + "?op=get&options=mr&search=#{long_keyid}").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => user.public_key, :headers => {})
    stub_request(:get, keyserver_url + "?fingerprint=on&op=vindex&options=mr&search=#{long_keyid}").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => vindex_response, :headers => {})
  }

  context "lookup without params" do
    let(:url) {host + "/api/v1/keyserver/lookup"}
    it "JSON" do
      get "#{url}"
      expect(response.status).to eq(200)
      expect(response.body).to eq('{"status":"error","message":"' + error_msg + '"}')
    end
  end
  
  context "lookup with wrong params" do
    let(:url) {host + "api/v1/keyserver/lookup?email=#{short_keyid}"}
    it "JSON" do
      get "#{url}"
      expect(response.status).to eq(200)
      expect(response.body).to eq('{"status":"error","message":"' + error_msg + '"}')
    end
  end
  
  context "lookup with email" do
    let(:url) {host + "api/v1/keyserver/lookup?email=#{email}"}
    it "JSON" do
      get "#{url}"
      expect(response.status).to eq(200)
      expect(response.body).to eq('{"status":"success","keys":[{"key_id":"' + short_keyid + '","public_key":"' + public_key + '"}]}')
    end
  end
  
  context "lookup with email upcase" do
    let(:url) {host + "api/v1/keyserver/lookup?email=#{email.upcase}"}
    it "JSON" do
      get "#{url}"
      expect(response.status).to eq(200)
      expect(response.body).to eq('{"status":"success","keys":[{"key_id":"' + short_keyid + '","public_key":"' + public_key + '"}]}')
    end
  end
  
  context "lookup with email and expired key" do
    let(:url) {host + "api/v1/keyserver/lookup?email=#{expired_email}"}
    it "JSON" do
      get "#{url}"
      expect(response.status).to eq(200)
      expect(response.body).to eq('{"status":"error","message":"' + error_msg + '"}')
    end
  end
  
  context "lookup with email and unknown key" do
    let(:url) {host + "api/v1/keyserver/lookup?email=#{unknown_email}"}
    it "JSON" do
      get "#{url}"
      expect(response.status).to eq(200)
      expect(response.body).to eq('{"status":"success","keys":[{"key_id":"' + short_keyid + '","public_key":"' + public_key + '"}]}')
    end
  end
  
  context "lookup with email and revoked key" do
    let(:url) {host + "api/v1/keyserver/lookup?email=#{revoked_email}"}
    it "JSON" do
      get "#{url}"
      expect(response.status).to eq(200)
      expect(response.body).to eq('{"status":"success","keys":[{"key_id":"' + short_keyid + '","public_key":"' + public_key + '"}]}')
    end
  end
  
  context "lookup with upcase email and valid key" do
    let(:url) {host + "api/v1/keyserver/lookup?email=#{upcase_email}"}
    it "JSON" do
      get "#{url}"
      expect(response.status).to eq(200)
      expect(response.body).to eq('{"status":"success","keys":[{"key_id":"' + short_keyid + '","public_key":"' + public_key + '"}]}')
    end
  end
  
  context "lookup with encoding email and valid key" do
    let(:url) {host + "api/v1/keyserver/lookup?email=#{encoding_email}"}
    it "JSON" do
      get "#{url}"
      expect(response.status).to eq(200)
      expect(response.body).to eq('{"status":"success","keys":[{"key_id":"' + short_keyid + '","public_key":"' + public_key + '"}]}')
    end
  end
  
  context "lookup with short keyid" do
    let(:url) {host + "api/v1/keyserver/lookup?keyid=#{short_keyid}"}
    it "JSON" do
      get "#{url}"
      expect(response.status).to eq(200)
      expect(response.body).to eq('{"status":"success","keys":[{"key_id":"' + short_keyid + '","public_key":"' + public_key + '"}]}')
    end
  end
  
  context "lookup with short keyid upcase" do
    let(:url) {host + "api/v1/keyserver/lookup?keyid=#{short_keyid.upcase}"}
    it "JSON" do
      get "#{url}"
      expect(response.status).to eq(200)
      expect(response.body).to eq('{"status":"success","keys":[{"key_id":"' + short_keyid + '","public_key":"' + public_key + '"}]}')
    end
  end
  
  context "lookup with long keyid" do
    let(:url) {host + "api/v1/keyserver/lookup?keyid=#{long_keyid}"}
    it "JSON" do
      get "#{url}"
      expect(response.status).to eq(200)
      expect(response.body).to eq('{"status":"success","keys":[{"key_id":"' + long_keyid + '","public_key":"' + public_key + '"}]}')
    end
  end
  
  context "lookup with long keyid upcase" do
    let(:url) {host + "api/v1/keyserver/lookup?keyid=#{long_keyid.upcase}"}
    it "JSON" do
      get "#{url}"
      expect(response.status).to eq(200)
      expect(response.body).to eq('{"status":"success","keys":[{"key_id":"' + long_keyid + '","public_key":"' + public_key + '"}]}')
    end
  end
end
