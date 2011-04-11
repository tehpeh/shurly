require 'sinatra'
require 'haml'
require 'active_record'
require 'logger'
require File.expand_path(File.join(File.dirname(__FILE__), 'lib/security'))
include Shurly::Security

configure do
  unless defined?(LOGGER)
    set :logging, false
    Dir.mkdir('log') unless File.exists?('log')
    class ::Logger; alias_method :write, :<<; end
    LOGGER = ::Logger.new("log/#{ENV['RACK_ENV']}.log",'weekly')
    use Rack::CommonLogger, LOGGER
  end
end

configure :development do |c|
  require "sinatra/reloader"
  #c.dont_reload "log/*"
  c.also_reload "lib/*.rb"
  #c.also_reload "*.haml"
end

HOMEPAGE = 'http://www.amc.org.au/' unless defined?(HOMEPAGE)

get '/' do
  redirect HOMEPAGE
end

get '/admin' do
  protected_by_ip(LOGGER)
  haml :'admin/index'
end
