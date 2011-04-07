require File.join(File.dirname(__FILE__), '..', 'shurly.rb')
require 'rack/test'
require 'rspec'
require 'rspec/autorun'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

RSpec.configure do |config|
  config.include Rack::Test::Methods
  def app() app ||= Sinatra::Application end
end