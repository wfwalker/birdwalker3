class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.text    "notes"
      t.integer "location_id",       :limit => 3
      t.integer "species_id",        :limit => 8
      t.integer "trip_id",           :limit => 3
      t.integer "rating"
      t.text    "original_filename"
    end

    add_index "photos", ["location_id"], :name => "LocationIndex"
    add_index "photos", ["rating"], :name => "RatingIndex"
    add_index "photos", ["species_id"], :name => "SpeciesIndex"
    add_index "photos", ["trip_id"], :name => "TripIndex"
  end

  def self.down
    drop_table :photos
  end
end
