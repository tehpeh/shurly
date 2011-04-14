require 'spec_helper'
require 'capybara/rspec'

describe 'Shurly', :type => :acceptance do
  #Capybara.default_driver = :selenium # <-- use Selenium driver
  #Capybara.javascript_driver = :selenium # <-- use Selenium for javascript

  Capybara.app = Shurly

  it 'displays a list of long and short urls' do
    Shurl.create(:long => 'http://rubygems.org/', :short => 'asdfgh')
    visit '/admin'
    page.should have_content 'http://rubygems.org/'
    page.should have_content 'asdfgh'
  end

  it 'saves a long url as a short url'#, :js => true do

end
