require 'sinatra'
require 'haml'
require 'active_record'

configure(:development) do |c|
  require "sinatra/reloader"
  #c.also_reload "*.rb"
end

get '/' do
  haml :index
end

get '/admin' do
  haml :'admin/index'
end