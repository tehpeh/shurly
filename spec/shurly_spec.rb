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
    let(:shurl) { mock(Shurl, 
      :long => 'http://rubygems.org/', 
      :short => 'qwerty') }
      
    before(:each) do
      Shurl.stub(:visit).and_return(shurl)
    end
      
    it 'finds a long URI' do
      Shurl.should_receive(:visit)
      get shurl.short
    end
    
    it 'redirects to a long URI' do
      get shurl.short
      follow_redirect!
      last_request.url.should eql shurl.long
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
  
  describe 'POST /admin/shurls' do
    let(:shurl) { mock(Shurl, :valid? => true, :to_json => "{shurl:{long:http://rubygems.org}}") }
    let(:params) { { :long => 'http://rubygems.org' } }
    
    before(:each) do
      stub protected_by_ip
      Shurl.stub(:create).and_return(shurl)
    end
    
    context 'only a long URI is provided' do
      it 'creates a new shurl' do
        params.merge!( { :short => '' } )
        Shurl.should_receive(:create).with(params).and_return(shurl)
        post '/admin/shurls', params
     end
    end
   
    context 'both long and short URIs are provided' do
      it 'creates a new shurl' do
        params.merge!( {:short => 'qwerty' } )
        Shurl.should_receive(:create).with(params).and_return(shurl)
        post '/admin/shurls', params
      end
    end
    
    context 'the long URI is good' do
      it 'returns status created' do
        post '/admin/shurls', params
        last_response.status.should eql 201
      end
      
      it 'returns the shurl as json' do
        post '/admin/shurls', params
        last_response.body.should eql shurl.to_json
      end
    end
    
    context 'the long URI is bad' do
      before(:each) do
        shurl.stub(:valid? => false)
      end

      it 'returns status bad request' do
        post '/admin/shurls', params
        last_response.status.should eql 400
      end
      
      it 'returns an error message as text' do
        post '/admin/shurls', params
        last_response.body.should eql "URL not valid"
      end
    end
    
    context 'a short URI could not be generated' do
      let(:error) { RuntimeError.new("error message") }
      
      before(:each) do
        Shurl.stub(:create).and_raise(error)
      end
      
      it 'returns status bad request' do
        post '/admin/shurls', params
        last_response.status.should eql 400
      end
      
      it 'returns an error message as text' do
        post '/admin/shurls', params
        last_response.body.should eql error.message
      end
    end
  end
end