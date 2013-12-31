require "spec_helper"

describe UsersController do
  
  describe "GET user" do
    it "has a 302 status code if user logged out" do
      user = build(:user)
      get :edit, uid: user.username
      expect(response.status).to eq(302)
    end
  end

end