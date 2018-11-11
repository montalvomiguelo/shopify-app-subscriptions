RACK_ENV = ENV['RACK_ENV']

require 'bundler'
Bundler.require(:default, RACK_ENV)

if Gem::Specification.find_all_by_name('dotenv').any?
  Dotenv.load
end

require_relative '../app/helpers/session_auth'

require_relative 'database'

require_relative '../models/shop'

require_relative '../app/repositories/shop_repository'

require_relative '../app/app'
