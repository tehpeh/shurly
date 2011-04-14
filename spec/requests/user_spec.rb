require 'spec_helper'
require 'capybara/rspec'

describe 'Shurly', :type => :acceptance do
  Capybara.app = Shurly

  before(:each) do
    Shurl.create(:long => 'http:///admin', :short => 'asdfgh')
  end

  describe 'accessing a short url' do
    it 'redirects to a long url' do
      visit '/asdfgh'
      current_path.should eql '/admin'
      # NOTE: rack_test does not support redirect to an external site,
      #  hence just redirect to /admin. Redirect to external does work 
      #  with selenium however (it "redirects", :driver => :selenium do)
    end
  end
end