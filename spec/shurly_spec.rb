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
    let(:shurl) { mock(Shurl, :valid? => true, :to_json => "{shurl:{long:http://rubygems.org}}") }
    let(:params) { { :long => 'http://rubygems.org' } }
    
    before(:each) do
      stub protected_by_ip
      Shurl.stub(:create).and_return(shurl)
    end
    
    context 'only a long url is provided' do
      it 'creates a new shurl' do
        params.merge!( { :short => '' } )
        Shurl.should_receive(:create).with(params).and_return(shurl)
        post '/admin/shurl', params
     end
    end
   
    context 'both long and short url are provided' do
      it 'creates a new shurl' do
        params.merge!( {:short => 'qwerty' } )
        Shurl.should_receive(:create).with(params).and_return(shurl)
        post '/admin/shurl', params
      end
    end
    
    context 'the long url is good' do
      it 'returns status created' do
        post '/admin/shurl', params
        last_response.status.should eql 201
      end
      
      it 'returns the shurl as json' do
        post '/admin/shurl', params
        last_response.body.should eql shurl.to_json
      end
    end
    
    context 'the long url is bad' do
      before(:each) do
        shurl.stub(:valid? => false)
      end

      it 'returns status bad request' do
        post '/admin/shurl', params
        last_response.status.should eql 400
      end
      
      it 'returns an error message as text' do
        post '/admin/shurl', params
        last_response.body.should eql "URI not valid"
      end
    end
  end
end