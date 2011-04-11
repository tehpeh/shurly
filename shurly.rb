require 'sinatra/base'
require 'haml'
require 'active_record'
require File.expand_path(File.join(File.dirname(__FILE__), 'lib/security'))
include Application::Security

class Shurly < Sinatra::Base
  configure :development do |c|
    require "sinatra/reloader"
    register Sinatra::Reloader
    also_reload "lib/*.rb"
    #also_reload "*.haml"
    #dont_reload "log/*"
  end

  HOMEPAGE = 'http://www.amc.org.au/' unless defined?(HOMEPAGE)

  get '/' do
    redirect HOMEPAGE
  end

  get '/admin' do
    protected_by_ip
    haml :'admin/index'
  end
end