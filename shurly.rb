require 'sinatra'
require 'haml'
require 'active_record'
require File.expand_path(File.join(File.dirname(__FILE__), 'lib/security'))
include Shurly::Security

configure :development do |c|
  require "sinatra/reloader"
  #c.dont_reload "log/*"
  #c.also_reload "*.haml"
end

HOMEPAGE = 'http://www.amc.org.au/' unless defined?(HOMEPAGE)

get '/' do
  redirect HOMEPAGE
end

get '/admin' do
  protected_by_ip
  haml :'admin/index'
end
