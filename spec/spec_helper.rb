ENV['RACK_ENV'] ||= 'test'

# Required env variables
ENV['HOME_URL'] = 'http://test.com/'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'shurly'))
require 'rack/test'
require 'rspec'
require 'database_cleaner'
require 'capybara/rspec'
require 'capybara-webkit'

Capybara.javascript_driver = :webkit
Capybara.app = Shurly

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

