class CreateShurls < ActiveRecord::Migration
  def self.up
    create_table :shurls do |t|
      t.string   :long,                :null => false
      t.string   :short,               :null => false, :limit => 6
      t.integer  :request_count,       :null => false, :default => 0
      t.datetime :last_request_at
      t.timestamps
    end
  end

  def self.down
    drop_table :shurls
  end
end