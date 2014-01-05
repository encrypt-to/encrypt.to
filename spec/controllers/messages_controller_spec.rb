require "spec_helper"

describe MessagesController do
  
  let(:user) { create :user }
  
  before {
    @pubkey = "-----BEGIN PGP PUBLIC KEY BLOCK-----\nVersion: SKS 1.1.4\nComment: Hostname: pgpkey.org\n\nmQENBFKyxokBCADIWV1KBbDnvGapdNIM2CSQjDnjfkVyvCGAhcyjlnlmLT23q61OPJasS+DE\nA0ujZtsPa2aGZK3o8ETSgwTREXxeG3n7tlTyXrqkTN/rh00YY/CIubmkeIKQfPDaLD2UDqGL\nn7gwFeSCtrfPkXFZsVN1GwiW3QsQfGH/c2CMt/t1BKu4RH5ZlLWSKifRPIFUK4gUEQ8SuwwV\nLhlqHLStVwEnEvilwiQIKeI3HQvJM3LecGwOflDHbl/pwbXlODidkPGIv9AzqaFjGqtHs9eH\nwcwflnncFJh8ey12LHPxaRUafExN/PMZZXbQFkSxd4rjXnHGFM0F9L6RZ/djMN17ihEDABEB\nAAG0HUVuY3J5cHQudG8gPGhlbGxvQGVuY3J5cHQudG8+iQE9BBMBCgAnBQJSssaJAhsDBQkH\nhh+ABQsJCAcDBRUKCQgLBRYCAwEAAh4BAheAAAoJEAyvHlsRSJofLJYIAKLSxtnTcqytoLES\n1mkmfXGd3N4IsVzpM1J/M3+fvk1YY6JF5SAYYgAhEiO/cqRHVdRCbhIbzRwxNYIdc37sAopx\ndq3xlrflon4lKPogp/07cFgTgyzFYrcWKaQ+1MX+LLRp0eqgGCaBMT6BLSCW69pfhGIbUg9Q\nv9PJVSRNcTU+TO6698kiKGCleYmAldqYLjbzmJdgDawiKfWlyf4aJTh/gRDL6mD/K17nppsa\n64PmJGccCQN7f00O2TSAwW7gZcJU+5djJetC0Y8PoPLBdXWH+pvsrxZcMjpTzA3RG5+O/naf\nr7M8JSCWE988XYw5z9YY4A4/LYPQmBQNA55WUCm5AQ0EUrLGiQEIALIGx1feux9O/r+8tPJm\nbS8x/8v+zWg7Y1Db5QRuPbWJbfqquWGyjeYMywgpFFyQrtO6sS8qz3dfufh2QCx1/6Tko+C+\ndMgPWy+W2KwQl2zwK4DTsE//rXAQrpQslRFvT7SwiQMj7gi/1CCz8y9gPn4GRbUfOkGobty6\nbxE7lK+5PziQ1IqFixW/pBby4MezfNS3CecaSPG0OBfwMAkrzjX8XYqZT0RXEwGqqsbHomJ4\n5ZD1DO1lbQUCLa8BxaZjNvyoLIGHWxXlHz8UqpwpWutIRF2J02R6YbTrBz0mGlzxlnyI1OzC\n43VypPhknJVRC8CEFGyF3ohQt8r3QmpNe8sAEQEAAYkBJQQYAQoADwUCUrLGiQIbDAUJB4Yf\ngAAKCRAMrx5bEUiaH3JFB/sH+EDJJHw0WpSHG/of73/k6D7abKoyRt2Q0JJEoQEJnSyBQFiS\nBFcS2GacUToXzbLksky27QLGThpGma78+9GHABIkf8dsJnPobOI3FMpWEmK9swURsD2r6aII\nOhkeQYZE77D7BqGllVORcb4m+Tkst6VeDsIsAoIuFG8LGNT6it/Fptwcx3AtilFICKV55RxC\nD+ziUtQAc64747QKjIJab/Gtz1vEOTiK3zty8R9SPKIQyfTNg7eCHtCBrKWQGiXBKv//lUKp\n3R+OR/PgB1AMNUXxREhg7eV4ehM33oP08jCmByN1D7xbuql1t1N9xpggqSKl5oHmMZoNjeJm\nF6rn\n=mMV8\n-----END PGP PUBLIC KEY BLOCK-----\r\n"
    stub_request(:get, "http://pgpkey.org/pks/lookup?exact=on&op=vindex&options=mr&search=hello@encrypt.to").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'pgpkey.org', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "info:1:2\npub:11489A1F:1:2048:1387447945::\nuid:Encrypt.to <hello@encrypt.to>:1387447945::\n\r\n", :headers => {})
    stub_request(:get, "http://pgpkey.org/pks/lookup?op=get&options=mr&search=0x11489A1F").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'pgpkey.org', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => @pubkey, :headers => {})
    stub_request(:get, "http://pgpkey.org/pks/lookup?fingerprint=on&op=vindex&options=mr&search=0x11489A1F").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'pgpkey.org', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "info:1:1\npub:11489A1F:1:2048:1387447945::\nuid:Encrypt.to <hello@encrypt.to>:1387447945::\n\r\n", :headers => {})
    stub_request(:get, "http://pgpkey.org/pks/lookup?fingerprint=on&op=vindex&options=mr&search=0x0caf1e5b11489a1f").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'pgpkey.org', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "info:1:1\npub:11489A1F:1:2048:1387447945::\nuid:Encrypt.to <hello@encrypt.to>:1387447945::\n\r\n", :headers => {})
    stub_request(:get, "http://pgpkey.org/pks/lookup?op=get&options=mr&search=0x0caf1e5b11489a1f").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'pgpkey.org', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => @pubkey, :headers => {})
  }    
    
  describe "GET new" do
    it "has a 302 status code if params empty" do
      get :new
      expect(response.status).to eq(302)
    end
  end
  
  describe "GET new" do
    it "has a 200 status code if params uid is local user" do
      get :new, uid: user.username
      expect(response.status).to eq(200)
    end
  end

  describe "GET new" do
    it "has a 200 status code if params uid is email" do
      get :new, uid: "hello@encrypt.to"
      expect(response.status).to eq(200)
      expect(assigns(:pubkey)).to eq(@pubkey)
    end
  end
  
  describe "GET new" do
    it "has a 200 status code if params uid is short keyid" do
      get :new, uid: "0x11489A1F"
      expect(response.status).to eq(200)
      expect(assigns(:pubkey)).to eq(@pubkey)
    end
  end
  
  describe "GET new" do
    it "has a 200 status code if params uid is long keyid" do
      get :new, uid: "0x0caf1e5b11489a1f"
      expect(response.status).to eq(200)
      expect(assigns(:pubkey)).to eq(@pubkey)
    end
  end

end