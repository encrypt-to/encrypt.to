source 'https://rubygems.org'

gem 'rails', '3.2.21'
gem 'thin'
gem "therubyracer"
gem 'jquery-rails'
gem 'devise'
gem 'stripe'
gem 'stripe_event'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem 'quiet_assets'
  gem 'sqlite3'
  gem 'rspec-rails', '2.99'
  gem 'factory_girl_rails'
end

group :test do
  gem 'faker' 
  gem 'capybara' 
  gem 'guard-rspec' 
  gem 'launchy' 
  gem 'poltergeist'
  gem 'email_spec'
  gem 'webmock'
  gem 'vcr'
end

group :production do
  gem 'mysql2'
end

