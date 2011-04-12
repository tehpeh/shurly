task(:environment) do
  ENV['RACK_ENV'] ||= 'development'
  require File.expand_path(File.join(File.dirname(__FILE__), 'shurly'))
  require 'active_record'
  require 'logger'
end

namespace :db do
  desc "Migrate the database"
  task(:migrate => :environment) do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end
end