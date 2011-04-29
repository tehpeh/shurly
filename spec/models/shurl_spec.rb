require 'spec_helper'

describe Shurl do
  describe '#long' do
    it 'is unique' do
      Shurl.create(:long => 'http://rubygems.org/', :short => 'qwerty')
      Shurl.create(:long => 'http://rubygems.org/', :short => 'asdfgh')
      Shurl.find_all_by_long('http://rubygems.org/').should have(1).item
    end
    
    it 'is a valid web address' do
      Shurl.new(:long => 'http://rubygems.org',  :short => 'qwerty').should be_valid
      Shurl.new(:long => 'https://rubygems.org', :short => 'asdfgh').should be_valid
      Shurl.new(:long => 'oops://rubygems.org',  :short => 'zxcvbn').should_not be_valid
    end
    
    it 'is normalized when saved' do
      shurl = Shurl.create(:long => 'http://rubygems.org')
      shurl.long.should eql 'http://rubygems.org/'
    end
    
    it 'does not have leading or trailing spaces' do
      shurl = Shurl.create(:long => '   http://rubygems.org   ')
      shurl.long.should eql 'http://rubygems.org/'
    end
  end
  
  describe '#short' do
    it 'is unique' do
      Shurl.create(:long => 'http://rubygems.org', :short => 'qwerty')
      Shurl.create(:long => 'http://google.com',   :short => 'qwerty')
      Shurl.find_all_by_short('qwerty').should have(1).item
    end
    
    it 'is generated on create/save' do
      shurl = Shurl.create(:long => 'http://rubygems.org')
      shurl.should be_valid
      shurl.short.size.should >= 1
      shurl.short.size.should <= 6
    end
  end
  
  describe '#visit' do
    before(:each) do
      Shurl.create(:long => 'http://rubygems.org', :short => 'qwerty')
    end
    
    it 'increments the request counter' do
      expect {Shurl.visit('qwerty')}.to change{Shurl.find_by_short('qwerty').request_count}.by(1)
    end
    
    it 'updates the last request at timestamp' do
      expect {Shurl.visit('qwerty')}.to change{Shurl.find_by_short('qwerty').last_request_at}
    end
  end
  
  describe '.create' do
    it 'reuses a record if long already exists' do
      first  = Shurl.create(:long => 'http://rubygems.org')
      second = Shurl.create(:long => 'http://rubygems.org')
      first.should eql second
      Shurl.all.should have(1).item
    end
  end
  
  describe '.create!' do
    it 'reuses a record if long already exists' do
      first  = Shurl.create!(:long => 'http://rubygems.org')
      second = Shurl.create!(:long => 'http://rubygems.org')
      first.should eql second
      Shurl.all.should have(1).item
    end
  end
  
  describe '.find_by_long' do
    it 'normalizes the parameter' do
      first = Shurl.create(:long => 'http://rubygems.org/')
      find  = Shurl.find_by_long('http://rubygems.org')
      find.should eql first
    end
  end
end