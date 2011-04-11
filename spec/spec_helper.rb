require File.expand_path(File.join(File.dirname(__FILE__), '..', 'shurly'))
require 'rack/test'
require 'rspec'
require 'rspec/autorun'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  def app
     app ||= Shurly
  end
end