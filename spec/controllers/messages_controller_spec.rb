require "spec_helper"

describe MessagesController do
  
  let(:user) { create :user }
  
  before {
    stub_request(:get, "http://pgpkey.org/pks/lookup?exact=on&op=vindex&options=mr&search=hello@encrypt.to").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "info:1:2\npub:11489A1F:1:2048:1387447945::\nuid:Encrypt.to <hello@encrypt.to>:1387447945::\n\r\n", :headers => {})
    stub_request(:get, "http://pgpkey.org/pks/lookup?op=get&options=mr&search=0x11489A1F").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => user.public_key, :headers => {})
    stub_request(:get, "http://pgpkey.org/pks/lookup?fingerprint=on&op=vindex&options=mr&search=0x11489A1F").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "info:1:1\npub:11489A1F:1:2048:1387447945::\nuid:Encrypt.to <hello@encrypt.to>:1387447945::\n\r\n", :headers => {})
    stub_request(:get, "http://pgpkey.org/pks/lookup?fingerprint=on&op=vindex&options=mr&search=0x0caf1e5b11489a1f").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "info:1:1\npub:11489A1F:1:2048:1387447945::\nuid:Encrypt.to <hello@encrypt.to>:1387447945::\n\r\n", :headers => {})
    stub_request(:get, "http://pgpkey.org/pks/lookup?op=get&options=mr&search=0x0caf1e5b11489a1f").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => user.public_key, :headers => {})
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
      expect(assigns(:pubkey)).to eq(user.public_key)
      expect(response.status).to eq(200)
    end
  end

  describe "GET new" do
    it "has a 200 status code if params uid is email" do
      get :new, uid: "hello@encrypt.to"
      expect(response.status).to eq(200)
      expect(assigns(:pubkey)).to eq(user.public_key)
    end
  end
  
  describe "GET new" do
    it "has a 200 status code if params uid is short keyid" do
      get :new, uid: "0x11489A1F"
      expect(response.status).to eq(200)
      expect(assigns(:pubkey)).to eq(user.public_key)
    end
  end
  
  describe "GET new" do
    it "has a 200 status code if params uid is long keyid" do
      get :new, uid: "0x0caf1e5b11489a1f"
      expect(response.status).to eq(200)
      expect(assigns(:pubkey)).to eq(user.public_key)
    end
  end

end