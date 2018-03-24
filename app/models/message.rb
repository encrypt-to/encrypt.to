class Message < ActiveRecord::Base
  attr_accessor :receiver, :body_input, :body_input, :body, :from, :to, :file, :filename, :keyid
end
