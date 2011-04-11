require 'sinatra'
require 'haml'
require 'active_record'
require File.expand_path(File.join(File.dirname(__FILE__), 'lib/application'))
include Shurly::Application

configure :development do
  require "sinatra/reloader"
  #also_reload "*.haml"
end

HOMEPAGE = 'http://www.amc.org.au/' unless defined?(HOMEPAGE)

get '/' do
  redirect HOMEPAGE
end

get '/admin' do
  protected_by_ip
  haml :'admin/index'
end
