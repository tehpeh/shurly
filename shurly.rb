require 'sinatra/base'
require 'haml'
require 'active_record'
require 'sqlite3'
require File.expand_path(File.join(File.dirname(__FILE__), 'lib', 'security'))
include Application::Security

database_config = YAML.load_file(File.join(File.dirname(__FILE__), 'config', 'database.yml'))

ActiveRecord::Base.establish_connection(
  database_config[ENV['RACK_ENV']]
)

Dir.glob(File.join(File.dirname(__FILE__), 'models', '*.rb')).each {|file| 
  require file
}

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
    @urls = Shurl.all
    haml :'admin/index'
  end
  
  get %r{^/([a-zA-Z0-9]{1,6})$} do |short|
    if shurl = Shurl.find_by_short(short)
      redirect shurl.long
    else
      redirect HOMEPAGE
    end
  end
end