RACK_ENV = ENV['RACK_ENV']

require 'bundler'
Bundler.require(:default, RACK_ENV)
