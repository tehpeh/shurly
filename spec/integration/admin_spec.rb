require 'spec_helper'
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'shurly'))
require 'capybara'
require 'capybara/dsl'
require 'test/unit'

describe Shurly do
  include Capybara
  #Capybara.default_driver = :selenium # <-- use Selenium driver

  Capybara.app = Shurly.new

  it "displays a list of long and short urls" do
    visit '/admin'
    page.should have_content('Shurly')
  end
end
