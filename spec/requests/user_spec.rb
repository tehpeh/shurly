require 'spec_helper'
require 'capybara/rspec'

describe "Shurly", :type => :acceptance do
  Capybara.app = Shurly

  it "redirects a short url to a long url" do
    Shurl.create(:long => '/admin', :short => 'asdfgh')
    visit '/asdfgh'
    current_path.should eql '/admin'
    # NOTE: rack_test does not support redirect to an external site,
    #  hence just redirect to /admin. Redirect to external does work 
    #  with selenium however (it "redirects", :driver => :selenium do)
  end
end