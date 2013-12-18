class Message < ActiveRecord::Base
  attr_accessible :tohash, :fromhash
  attr_accessor :body_input, :body_input, :body, :from, :to
end
