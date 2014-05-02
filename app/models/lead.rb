class Lead < ActiveRecord::Base
  attr_accessible :email
  
  validates :email, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }

end
