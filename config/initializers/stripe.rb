Stripe.api_key = APP_CONFIG['stripe_api_key']
STRIPE_PUBLIC_KEY = APP_CONFIG['stripe_public_key']

StripeEvent.setup do
  subscribe 'customer.subscription.deleted' do |event|
    user = User.find_by_customer_id(event.data.object.customer)
    user.expire
  end
end