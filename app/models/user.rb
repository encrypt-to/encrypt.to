class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :public_key, :login, :username, :email, :password, :password_confirmation, :remember_me
  attr_accessor :login
    
  validates :public_key, :presence => { :message => 'Public key cannot be blank!' }
  validates :username, :uniqueness => { :message => 'Sorry, username exists!', :case_sensitive => false } 
  validates :username, :format => { :message => 'Username: whitespaces and other characters not allowed.', with: /\A[a-zA-Z0-9]+\Z/ }
   
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end  
   
end
