class Message < ActiveRecord::Base
  attr_accessible :body_input, :body, :from, :to
  attr_accessor :body_input
    
  validates :body, presence: true
  validates :from, presence: true, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }  
  
end
