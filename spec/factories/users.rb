require 'faker' 

FactoryGirl.define do 
  factory :user do |f| 
    f.username { "info" } 
    f.email { Faker::Internet.email } 
    f.password { "password" }
    f.public_key { "-----BEGIN PGP PUBLIC KEY BLOCK-----" } 
  end 
end