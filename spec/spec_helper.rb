require File.expand_path(File.join(File.dirname(__FILE__), '..', 'shurly'))
require 'rack/test'
require 'rspec'
require 'rspec/autorun'

set :environment, :test

RSpec.configure do |config|
  config.include Rack::Test::Methods
  def app() app ||= Sinatra::Application end
end