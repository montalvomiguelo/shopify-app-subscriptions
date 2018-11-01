source 'https://rubygems.org'

ruby '2.5.1'

gem 'sinatra'
gem 'sequel'

group :production do
  gem 'mysql2'
end

group :development, :test do
  gem 'byebug'
  gem 'sqlite3'
end

group :test do
  gem 'rack-test'
  gem 'rspec'
end
