require "spec_helper"

describe MessagesController do
  
  describe "GET new" do
    it "has a 302 status code if params empty" do
      get :new
      expect(response.status).to eq(302)
    end
  end
  
  describe "GET new" do
    it "has a 200 status code if params empty" do
      get :new, uid: "hello@encrypt.to"
      expect(response.status).to eq(302)
    end
  end

end