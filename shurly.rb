require 'sinatra'
require 'haml'
require 'active_record'

configure(:development) do |c|
  require "sinatra/reloader"
  #c.also_reload "*.rb"
end

HOMEPAGE = 'http://www.amc.org.au/'

get '/' do
  redirect HOMEPAGE
end

get '/admin' do
  haml :'admin/index'
end