ENV['RACK_ENV'] ||= 'test'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'shurly'))
require 'rack/test'
require 'rspec'
require 'rspec/autorun'
require 'database_cleaner'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  def app
     app ||= Shurly
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end