require 'spec_helper'

describe 'Shurly' do
  describe 'GET /' do
    it 'redirects to home' do
      get '/'
      follow_redirect!
      last_request.url.should eql 'http://www.amc.org.au/'
    end
  end
end