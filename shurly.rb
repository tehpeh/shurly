require 'sinatra/base'
require 'haml'
require 'sass'
require 'active_record'
require 'set_theory'
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

  get '/stylesheets/:name.css' do
   content_type 'text/css', :charset => 'utf-8'
   scss :"#{params[:name]}"
  end

  get '/admin' do
    protected_by_ip
    haml :'admin/index'
  end

  get '/admin/shurls' do
    protected_by_ip
    content_type :json
    status 200

    case params[:format]
      when 'datatables' then
        {"aaData" => Shurl.all.map { |s| [
          s.long,
          s.short,
          s.request_count,
          s.last_request_at
        ] }}.to_json
      else
        Shurl.all.to_json
    end
  end

  post '/admin/shurls' do
    protected_by_ip
    content_type :json
    begin
      shurl = Shurl.create(:long => params[:long], :short => params[:short])
      if shurl.valid?
        status 201 # Created
        shurl.to_json
      else
        status 400 # Bad request
        "URL not valid"
      end
    rescue Exception => e
      status 400 # Bad request
      e.message
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