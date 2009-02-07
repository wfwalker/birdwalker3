# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 8) do

  create_table "counties", :force => true do |t|
    t.text    "name",     :limit => 255
    t.integer "state_id"
  end

  create_table "countyfrequency", :id => false, :force => true do |t|
    t.string  "common_name"
    t.integer "frequency",   :limit => 1
    t.integer "species_id",  :limit => 8
  end

  create_table "families", :force => true do |t|
    t.text    "latin_name"
    t.text    "common_name"
    t.integer "taxonomic_sort_id"
  end

  create_table "locations", :force => true do |t|
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

  create_table "photos", :force => true do |t|
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

  create_table "sightings", :force => true do |t|
    t.text    "notes"
    t.boolean "exclude",                  :default => false, :null => false
    t.boolean "heard_only",               :default => false, :null => false
    t.integer "location_id", :limit => 3
    t.integer "species_id",  :limit => 8
    t.integer "trip_id",     :limit => 3
  end

  add_index "sightings", ["exclude"], :name => "ExcludeIndex"
  add_index "sightings", ["location_id"], :name => "LocationIndex"
  add_index "sightings", ["species_id"], :name => "SpeciesIndex"
  add_index "sightings", ["trip_id"], :name => "TripIndex"

  create_table "species", :force => true do |t|
    t.string  "abbreviation",  :limit => 6
    t.text    "latin_name"
    t.text    "common_name"
    t.text    "notes"
    t.text    "reference_url"
    t.boolean "aba_countable",              :default => true, :null => false
    t.integer "family_id"
  end

  add_index "species", ["aba_countable"], :name => "aba_countableIndex"
  add_index "species", ["abbreviation"], :name => "AbbreviationIndex"

  create_table "states", :force => true do |t|
    t.string "name",         :limit => 16
    t.string "abbreviation", :limit => 2
    t.text   "notes"
  end

  add_index "states", ["abbreviation"], :name => "AbbreviationIndex"

  create_table "taxonomy", :force => true do |t|
    t.string "hierarchy_level", :limit => 16
    t.text   "latin_name"
    t.text   "common_name"
    t.text   "notes"
    t.text   "reference_url"
  end

  add_index "taxonomy", ["hierarchy_level"], :name => "hierarchyLevelIndex"
  add_index "taxonomy", ["id"], :name => "idIndex"

  create_table "trips", :force => true do |t|
    t.text "leader"
    t.text "reference_url"
    t.text "name"
    t.text "notes"
    t.date "date"
  end

  add_index "trips", ["date"], :name => "dateIndex"

  create_table "users", :force => true do |t|
    t.text "name"
    t.text "password"
  end

end
