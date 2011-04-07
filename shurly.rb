require 'sinatra'
require 'haml'
require 'active_record'

configure :development do
  require "sinatra/reloader"
  #also_reload "*.haml"
end

HOMEPAGE = 'http://www.amc.org.au/' unless defined?(HOMEPAGE)

get '/' do
  redirect HOMEPAGE
end

get '/admin' do
  haml :'admin/index'
end