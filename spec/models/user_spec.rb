require 'spec_helper'

describe User do
  it "has a valid factory" do
    create(:user).should be_valid
  end
  it "is invalid without a username" do
    build(:user, username: nil).should_not be_valid
  end
  it "is invalid without a password" do
    build(:user, password: nil).should_not be_valid
  end
  it "is invalid without a public key" do
    build(:user, public_key: nil).should_not be_valid
  end
  
end