class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string  "name"
      t.text    "reference_url"
      t.text    "city"
      t.integer "county_id"
      t.text    "notes"
      t.float   "latitude",      :limit => 15, :default => 0.0
      t.float   "longitude",     :limit => 15, :default => 0.0
      t.boolean "photo",                       :default => false
    end
      
    add_index "locations", ["name"], :name => "NameIndex"
  end

  def self.down
    drop_table :locations
  end
end
