require 'spec_helper'
require 'capybara'
require 'capybara/dsl'
require 'test/unit'

describe Shurly do
  include Capybara
  #Capybara.default_driver = :selenium # <-- use Selenium driver
  Capybara.javascript_driver = :selenium # <-- use Selenium for javascript only

  Capybara.app = Shurly.new

  it "displays a list of long and short urls" do
    Shurl.create(:long => 'http://www.amc.org.au/', :short => 'asdfgh')
    visit '/admin'
    page.should have_content 'http://www.amc.org.au/'
    page.should have_content 'asdfgh'
  end

  it "converts a long url into a short url", :js => true# do

end
