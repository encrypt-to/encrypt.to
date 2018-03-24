require 'rails_helper'

describe User, type: :model do
  it "has a valid factory" do
    expect(create(:user)).to be_valid
  end
  it "is invalid without a username" do
    expect(build(:user, username: nil)).not_to eq(be_valid)
  end
  it "is invalid without a password" do
    expect(build(:user, password: nil)).not_to eq(be_valid)
  end
  it "is invalid without a public key" do
    expect(build(:user, public_key: nil)).not_to eq(be_valid)
  end
  
end
