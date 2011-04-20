class AddIndicesToShurls < ActiveRecord::Migration
  def self.up
    add_index :shurls, :short
    add_index :shurls, :long
  end

  def self.down
    remove_index :shurls, :short
    remove_index :shurls, :long
  end
end
