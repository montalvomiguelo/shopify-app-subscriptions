source 'https://rubygems.org'

ruby '2.5.1'

gem 'sinatra'
gem 'sequel'
gem 'activesupport', require: 'active_support/all'
gem 'omniauth-shopify-oauth2'
gem 'sinatra-contrib'

group :production do
  gem 'mysql2'
end

group :development, :test do
  gem 'byebug'
  gem 'sqlite3'
  gem 'dotenv'
end

group :test do
  gem 'rack-test'
  gem 'rspec'
end
