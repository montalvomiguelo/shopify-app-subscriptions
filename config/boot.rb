RACK_ENV = ENV['RACK_ENV']

require 'bundler'
Bundler.require(:default, RACK_ENV)

require_relative '../app/helpers/session_auth'

require_relative '../app/repositories/shop_repository'

require_relative '../app/app'
