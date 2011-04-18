require 'sinatra/base'
require 'haml'
require 'sass'
require 'active_record'
autoload :Application, File.expand_path(File.join(File.dirname(__FILE__), 'lib', 'application'))
include Application::Security
include Application::Logging
autoload :UriValidator, File.expand_path(File.join(File.dirname(__FILE__), 'lib', 'uri_validator'))

# ActiveRecord models
database_config = YAML.load_file(File.join(File.dirname(__FILE__), 'config', 'database.yml'))
ActiveRecord::Base.establish_connection(
  database_config[ENV['RACK_ENV']]
)
Dir.glob(File.join(File.dirname(__FILE__), 'models', '*.rb')).each {|file| 
  require file
}

class Shurly < Sinatra::Base
  configure :development do |c|
    require 'sqlite3'
    require "sinatra/reloader"
    register Sinatra::Reloader
    also_reload "lib/*.rb"
    also_reload "models/*.rb"
    #also_reload "*.haml"
    #dont_reload "log/*"
  end
  
  configure :test do
    require 'sqlite3'
  end
  
  configure do
    set :app_file, File.expand_path(__FILE__)
  end

  HOMEPAGE = 'http://www.amc.org.au/' unless defined?(HOMEPAGE)

  get '/' do
    redirect HOMEPAGE
  end
  
  get '/stylesheets/screen.css' do
    scss :screen
  end

  get '/admin' do
    protected_by_ip
    @urls = Shurl.all
    haml :'admin/index'
  end

  post '/admin/shurl' do
    protected_by_ip
    content_type :json
    shurl = Shurl.create(:long => params[:long], :short => params[:short])
    if shurl.valid?
      status 201 # Created
      shurl.to_json
    else
      status 400 # Bad request
      "URI not valid"
    end
  end

  get %r{^/([a-zA-Z0-9]{1,6})$} do |short|
    if shurl = Shurl.visit(short)
      redirect shurl.long
    else
      redirect HOMEPAGE
    end
  end
end