require "spec_helper"

describe UsersController do
  
  let(:user) { create :user }

  context "anonymous user" do
  
    describe "edit user" do
      it "has a 302 status code if user logged out" do
        user = build(:user)
        get :edit, uid: user.username, context: "publickey"
        expect(response.status).to eq(302)
      end
    end
    
    describe "edit user" do
      it "has a 302 status code if user logged out" do
        user = build(:user)
        get :edit, uid: user.username, context: "layout"
        expect(response.status).to eq(302)
      end
    end
    
  end
  
  context "authenticated user" do
  
    before do
      sign_in user
    end
  
    describe "edit user" do
      it "has a 200 status code if user logged in" do
        user = build(:user)
        get :edit, uid: user.username, context: "publickey"
        expect(response.status).to eq(200)
      end
    end
    
    describe "edit user" do
      it "has a 200 status code if user logged in" do
        user = build(:user)
        get :edit, uid: user.username, context: "layout"
        expect(response.status).to eq(200)
      end
    end
    
    describe "update user" do
      it "has a 302 status code if user logged in" do
        user = build(:user)
        post :update, uid: user.username, public_key: '-----END PGP PUBLIC KEY BLOCK-----'
        expect(response.status).to eq(302)
        flash[:notice].should match('Public key was successfully updated.')
      end
    end
    
  end

end
