class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :public_key, :email, :password, :password_confirmation, :remember_me
  
  validates :public_key, :presence => { :message => 'Public key cannot be blank!' }
   
end
