require 'spec_helper'

describe 'Shurly user', :type => :request do

  before(:each) do
    Shurl.create(:long => 'http:///admin', :short => 'asdfgh')
  end

  describe 'accessing a short URI' do
    it 'is redirected to a long URI' do
      visit '/asdfgh'
      current_path.should eql '/http:/admin'
      # NOTE: rack_test does not support redirect to an external site,
      #  hence just redirect to /admin. Redirect to external does work 
      #  with selenium however (it "redirects", :driver => :selenium do)
    end
  end
end