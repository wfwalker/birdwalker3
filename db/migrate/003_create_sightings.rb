class CreateSightings < ActiveRecord::Migration
  def self.up
    create_table :sightings do |t|
      t.text    "notes"
      t.boolean "exclude",                  :default => false, :null => false
      t.boolean "heard_only",               :default => false, :null => false
      t.integer "location_id", :limit => 3
      t.integer "species_id",  :limit => 8
      t.integer "trip_id",     :limit => 3
      t.integer "count",       :limit => 3
    end

    add_index "sightings", ["exclude"], :name => "ExcludeIndex"
    add_index "sightings", ["location_id"], :name => "LocationIndex"
    add_index "sightings", ["species_id"], :name => "SpeciesIndex"
    add_index "sightings", ["trip_id"], :name => "TripIndex"
  end

  def self.down
    drop_table :sightings
  end
end
