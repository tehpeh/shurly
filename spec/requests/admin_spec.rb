require 'spec_helper'

describe 'Shurly admin', :type => :request do

  it 'sees a list of long and short URIs', :js => true do
    Shurl.create(:long => 'http://rubygems.org/', :short => 'asdfgh')
    visit '/admin'
    page.should have_content 'http://rubygems.org/'
    page.should have_content 'asdfgh'
  end

  it 'can save a long URI as a short URI', :js => true do
    visit '/admin'
    fill_in 'long', :with => 'http://rubygems.org/'
    click_on 'add'
    find('textarea#short', :text => /\/[a-z]{6}/i).should be
    Shurl.exists?(:long => 'http://rubygems.org/').should be
  end
  
  it 'can save a list of long URIs to short URIs', :js => true do
    visit '/admin'
    fill_in 'long', :with => "http://rubygems.org/\nhttp://google.com/"
    click_on 'add'
    find('textarea#short', :text => /\/[a-z]{6}/i).should be
    Shurl.exists?(:long => 'http://rubygems.org/').should be
    Shurl.exists?(:long => 'http://google.com/').should be
  end
end
