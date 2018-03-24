require 'rails_helper'

describe "routing to profiles", type: :routing do
  
  it "routes /:uid to messages#new for email" do
    email = "hello@encrypt.to"
    expect(:get => "/#{email}").to route_to(
      :controller => "messages",
      :action => "new",
      :uid => email
    )
  end

  it "routes /:uid to messages#new for long_keyid" do
    long_keyid = "0x0caf1e5b11489a1f"
    expect(:get => "/#{long_keyid}").to route_to(
      :controller => "messages",
      :action => "new",
      :uid => long_keyid
    )
  end
  
  it "routes /:uid to messages#new for short_keyid" do
    short_keyid = "0x11489A1F"
    expect(:get => "/#{short_keyid}").to route_to(
      :controller => "messages",
      :action => "new",
      :uid => short_keyid
    )
  end

end
