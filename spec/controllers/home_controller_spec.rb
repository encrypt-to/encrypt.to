require "rails_helper"

describe HomeController, type: :controller do
  
  describe "GET index" do
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
  end
  
  describe "GET terms" do
    it "has a 200 status code" do
      get :terms
      expect(response.status).to eq(200)
    end
  end
  
  describe "GET privacy" do
    it "has a 200 status code" do
      get :privacy
      expect(response.status).to eq(200)
    end
  end
end
