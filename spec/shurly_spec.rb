require 'spec_helper'

describe Sinatra::Application do
  describe 'GET /' do
    it 'redirects to home' do
      get '/'
      follow_redirect!
      last_request.url.should eql 'http://www.amc.org.au/'
    end
  end
  
  describe 'GET /admin' do
    it 'renders ok' do
      get '/admin'
      last_response.should be_ok
    end
    
    it 'displays a list of long and short urls'
    # maybe split this out into an integration test
  end
end