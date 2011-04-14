require 'spec_helper'
require 'capybara/rspec'

describe 'Shurly admin', :type => :acceptance do
  #Capybara.default_driver = :selenium # <-- use Selenium driver
  #Capybara.javascript_driver = :selenium # <-- use Selenium for javascript

  Capybara.app = Shurly

  it 'sees a list of long and short urls' do
    Shurl.create(:long => 'http://rubygems.org/', :short => 'asdfgh')
    visit '/admin'
    page.should have_content 'http://rubygems.org/'
    page.should have_content 'asdfgh'
  end

  it 'can save a long url as a short url', :js => true do
    visit '/admin'
    fill_in 'long', :with => 'http://rubygems.org/'
    click_on 'add'
    find('textarea#short', :text => /undefined\/[a-z]{6}/i).should be  # in selenium hostname is 'undefined'
    Shurl.exists?(:long => 'http://rubygems.org/').should be
  end
  
  it 'can save a list of long urls to short urls', :js => true do
    visit '/admin'
    fill_in 'long', :with => "http://rubygems.org/\nhttp://google.com/"
    click_on 'add'
    find('textarea#short', :text => /undefined\/[a-z]{6}/i).should be
    Shurl.exists?(:long => 'http://rubygems.org/').should be
    Shurl.exists?(:long => 'http://google.com/').should be
  end
end
