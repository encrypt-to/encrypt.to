require "rails_helper"

email = "hello@encrypt.to"
expired_email = "expired@encrypt.to"
unknown_email = "unknown@encrypt.to"
invalid_email = "test@encrypt.to.to"
short_keyid = "0x11489a1f"
long_keyid = "0x0caf1e5b11489a1f"
invalid_keyid = "0x0x11489a1f"
vindex_response = "info:1:2\npub:11489A1F:1:2048:1387447945:1587447945:\nuid:Encrypt.to <hello@encrypt.to>:1387447945::\n\r\n"
vindex_response_expired = "info:1:2\npub:11489A1F:1:2048:1387447945:1287447945:\nuid:Encrypt.to <expired@encrypt.to>:1387447945::\n\r\n"
vindex_response_unknown = "info:1:2\npub:11489A1F:1:2048:1387447945::\nuid:Encrypt.to <unknown@encrypt.to>:1387447945::\n\r\n"
vindex_response_invalid = ""
message = "-----BEGIN PGP MESSAGE-----\nVersion: OpenPGP.js v.1.20130306\nComment: http://openpgpjs.org\n\nwcBMA3VR7lR02L1RAQf/T/DHX8b1Ka65EpXZcffKjgzYch11Kvm0SJcXne0G\n2M/k3vAsKnru+zsbOnV+9IpXIywJIyDWOFasrqZggmHlMVOSr5CjKX27RspY\nfRPJ/9AU+Oada0iqocMIexY1QkoeGO16je0QWd7sbq+ejZZbJwfSvG/orW87\nHhX/r0pfUEpcwSNQcc4588NQ6qRvi9QwXt+Ykktozqi+JGurWOotLwe4/SQk\nJ2PePxYX6hBP1mUW7WVIHL3imM44Fe4x8yhFCVWpZDeKY1aA4B5Sg4STuuCJ\nnUgnpoeC4lDX+PyEoFq+QUi1sTHWdrZq6u8LUYX/Ode6tW/olVxYOoabWZ3y\nUtI4AZITMAgOOeDueWxbR214x3wqMQc7W1IuZWpzL4ogE+zjWwHU1j6EgD31\npEnyQbmBDMgGlxPqcis=\n=W15x\n-----END PGP MESSAGE-----"
keyserver_url = "http://pgpkey.org/pks/lookup"

describe MessagesController, type: :controller do
  
  let(:user) { create :user }
  
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
    stub_request(:get, keyserver_url + "?exact=on&op=vindex&options=mr&search=#{invalid_email}").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => vindex_response_invalid, :headers => {})
    stub_request(:get, keyserver_url + "?op=get&options=mr&search=#{short_keyid}").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => user.public_key, :headers => {})
    stub_request(:get, keyserver_url + "?fingerprint=on&op=vindex&options=mr&search=#{short_keyid}").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => vindex_response, :headers => {})
    stub_request(:get, keyserver_url + "?fingerprint=on&op=vindex&options=mr&search=#{long_keyid}").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => vindex_response, :headers => {})
    stub_request(:get, keyserver_url + "?op=get&options=mr&search=#{long_keyid}").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => user.public_key, :headers => {})
    stub_request(:get, keyserver_url + "?op=get&options=mr&search=#{invalid_keyid}").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => vindex_response_invalid, :headers => {})
    stub_request(:get, keyserver_url + "?fingerprint=on&op=vindex&options=mr&search=#{invalid_keyid}").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => vindex_response_invalid, :headers => {})
  }
    
  describe "GET new" do
    it "has a 302 status code if params empty" do
      get :new
      expect(response.status).to eq(302)
      expect(flash[:notice]).to eq(I18n.t('messages.new.invalid_link'))
    end
  end
  
  describe "GET new" do
    it "has a 302 status code if params invalid email" do
      get :new, uid: invalid_email
      expect(response.status).to eq(302)
      expect(flash[:notice]).to eq(I18n.t('messages.new.no_public_key'))
    end
  end
  
  describe "GET new" do
    it "has a 302 status code if params invalid key-id" do
      get :new, uid: invalid_keyid
      expect(response.status).to eq(302)
      expect(flash[:notice]).to eq(I18n.t('messages.new.no_mail'))
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
      get :new, uid: email
      expect(response.status).to eq(200)
      expect(assigns(:pubkey)).to eq(user.public_key)
    end
  end
  
  describe "GET new" do
    it "has a 302 status code if params uid is an expired email" do
      get :new, uid: expired_email
      expect(response.status).to eq(302)
      expect(flash[:notice]).to eq(I18n.t('messages.new.no_public_key'))
    end
  end
  
  describe "GET new" do
    it "has a 200 status code if params uid is an unknown expired date email" do
      get :new, uid: unknown_email
      expect(response.status).to eq(200)
      expect(assigns(:pubkey)).to eq(user.public_key)
    end
  end
  
  describe "GET new" do
    it "has a 200 status code if params uid is email upcase" do
      get :new, uid: email.upcase
      expect(response.status).to eq(200)
      expect(assigns(:pubkey)).to eq(user.public_key)
    end
  end
  
  describe "GET new" do
    it "has a 200 status code if params uid is short keyid" do
      get :new, uid: short_keyid
      expect(response.status).to eq(200)
      expect(assigns(:pubkey)).to eq(user.public_key)
    end
  end
  
  describe "GET new" do
    it "has a 200 status code if params uid is short keyid upcase" do
      get :new, uid: short_keyid.upcase
      expect(response.status).to eq(200)
      expect(assigns(:pubkey)).to eq(user.public_key)
    end
  end
  
  describe "GET new" do
    it "has a 200 status code if params uid is long keyid" do
      get :new, uid: long_keyid
      expect(response.status).to eq(200)
      expect(assigns(:pubkey)).to eq(user.public_key)
    end
  end
  
  describe "GET new" do
    it "has a 200 status code if params uid is long keyid upcase" do
      get :new, uid: long_keyid.upcase
      expect(response.status).to eq(200)
      expect(assigns(:pubkey)).to eq(user.public_key)
    end
  end
  
  describe "POST message" do
    it "has a 302 status code if params are valid" do
      ActionMailer::Base.deliveries.clear
      from = email
      post :create, :message => {to: email, from: from, body: message}
      expect(response.status).to eq(302)
    end
  end
  
  describe "POST message" do
    it "has a 302 status code if params are invalid" do
      message = ""
      from = email
      post :create, :message => {to: user.email, from: from, body: message}
      expect(response.status).to eq(302)
    end
  end

end
