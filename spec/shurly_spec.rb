require 'spec_helper'

describe Shurly do
  include Rack::Test::Methods
  def app
    Shurly
  end
  
  describe 'GET /' do
    it 'redirects to home' do
      get '/'
      follow_redirect!
      last_request.url.should eql 'http://www.amc.org.au/'
    end
  end
  
  describe 'GET /admin' do
    before(:each) do
      stub protected_by_ip
    end
    
    it 'renders ok' do
      get '/admin'
      last_response.should be_ok
    end
  end
  
  describe 'GET /qwerty' do
    let(:url) { mock(Shurl, 
      :long => 'http://rubygems.org/', 
      :short => 'qwerty') }
      
    before(:each) do
      Shurl.stub(:visit).and_return(url)
    end
      
    it 'finds a long url' do
      Shurl.should_receive(:visit)
      get url.short
    end
    
    it 'redirects to a long url' do
      get url.short
      follow_redirect!
      last_request.url.should eql url.long
    end
  end
  
  describe 'GET /baduri' do
    it 'redirects to home' do
      Shurl.stub(:visit).and_return(false)
      get '/baduri'
      follow_redirect!
      last_request.url.should eql 'http://www.amc.org.au/'
    end
  end
  
  describe 'POST /admin/shurl' do
    before(:each) do
      stub protected_by_ip
    end
    
    context 'only a long url is provided' do
      it 'creates a new shurl' do
        params = { :url => { 'long' => 'http://rubygems.org', 'short' => nil } }
        Shurl.should_receive(:create).with(params[:url]).and_return(true)
        post '/admin/shurl', params
     end
   end
   
   context 'both long and short url are provided' do
     it 'creates a new shurl' do
       params = { :url => { 'long' => 'http://rubygems.org', 'short' => 'qwerty' } }
       Shurl.should_receive(:create).with(params[:url]).and_return(true)
       post '/admin/shurl', params
    end
  end
  end
end