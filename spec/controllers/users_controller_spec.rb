require "spec_helper"

describe UsersController do
  
  let(:user) { create :user }

  context "anonymous user" do
  
    describe "GET user" do
      it "has a 302 status code if user logged out" do
        user = build(:user)
        get :edit, uid: user.username
        expect(response.status).to eq(302)
      end
    end
    
  end
  
  context "authenticated user" do
  
    before do
      sign_in user
    end
  
    describe "GET user" do
      it "has a 200 status code if user logged in" do
        user = build(:user)
        get :edit, uid: user.username
        expect(response.status).to eq(200)
      end
    end
    
  end

end