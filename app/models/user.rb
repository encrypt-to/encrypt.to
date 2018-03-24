class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :name, :login, :stripe_token
  
  validates :public_key, :presence => { :message => 'Public key cannot be blank!' }
  validates :username, :uniqueness => { :message => 'Sorry, username exists!', :case_sensitive => false } 
  validates :username, :format => { :message => 'Username: whitespaces and other characters not allowed.', with: /\A[a-zA-Z0-9]+\Z/ }
   
  before_save :update_stripe  
  before_destroy :cancel_subscription
    
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end 
  
  def update_stripe
    return if username == "admin" or Rails.env.test? or (!self.new_record? and customer_id.nil?)
    if customer_id.nil?
      if !stripe_token.present?
        raise "Stripe token not present. Can't create account."
      end
      customer = Stripe::Customer.create(
        :email => email,
        :description => username,
        :card => stripe_token,
        :plan => plan
      )
    else
      customer = Stripe::Customer.retrieve(customer_id)
      if stripe_token.present?
        customer.card = stripe_token
      end
      customer.email = email
      customer.description = username
      customer.save
    end
    self.last_4_digits = customer.cards.data.first["last4"]
    self.customer_id = customer.id
    self.stripe_token = nil
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: " + e.message
    errors.add :base, "#{e.message}."
    self.stripe_token = nil
    false
  end
  
  def cancel_subscription
    unless customer_id.nil?
      customer = Stripe::Customer.retrieve(customer_id)
      unless customer.nil? or customer.respond_to?('deleted')
        subscription = customer.subscriptions.data[0]
        if subscription && (subscription.status == 'active' or subscription.status == 'trialing')
          customer.cancel_subscription
        end
      end
    end
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: " + e.message
    errors.add :base, "Unable to cancel your subscription. #{e.message}."
    false
  end
  
  def expire
    MessageMailer.expire_email(self).deliver_now
    destroy
  end 
   
end
