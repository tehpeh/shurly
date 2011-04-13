require 'spec_helper'

describe Shurl do
  describe '#long' do
    it 'is unique' do
      Shurl.create(:long => 'http://rubygems.org', :short => 'qwerty')
      Shurl.create(:long => 'http://rubygems.org', :short => 'asdfgh')
      Shurl.find_all_by_long('http://rubygems.org').should have(1).item
    end
    
    it 'is a valid web address' do
      Shurl.new(:long => 'http://rubygems.org',  :short => 'qwerty').should be_valid
      Shurl.new(:long => 'https://rubygems.org', :short => 'asdfgh').should be_valid
      Shurl.new(:long => 'oops://rubygems.org',  :short => 'zxcvbn').should_not be_valid
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
  
  describe '.create' do
    it 'is reuses a record if long already exists' do
      first  = Shurl.create(:long => 'http://rubygems.org')
      second = Shurl.create(:long => 'http://rubygems.org')
      first.should eql second
      Shurl.all.should have(1).item
    end
  end
  
  describe '.create!' do
    it 'is reuses a record if long already exists' do
      first  = Shurl.create!(:long => 'http://rubygems.org')
      second = Shurl.create!(:long => 'http://rubygems.org')
      first.should eql second
      Shurl.all.should have(1).item
    end
  end
end