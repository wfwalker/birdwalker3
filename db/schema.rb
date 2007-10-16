# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define() do

  create_table "locations", :force => true do |t|
    t.column "name",          :string
    t.column "referenceurl",  :string
    t.column "city",          :string
    t.column "county",        :string
    t.column "state",         :string
    t.column "notes",         :text
    t.column "latlongsystem", :string
    t.column "latitude",      :float
    t.column "longitude",     :float
    t.column "photo",         :integer, :limit => 2
  end

  create_table "sightings", :force => true do |t|
    t.column "oldspeciesabbrev", :string
    t.column "oldlocationname",  :string
    t.column "notes",            :text
    t.column "exclude",          :integer, :limit => 2
    t.column "photo",            :integer, :limit => 2
    t.column "date",             :date
    t.column "trip_id",          :integer
    t.column "species_id",       :integer, :limit => 20
    t.column "location_id",      :integer
  end

  add_index "sightings", ["trip_id"], :name => "trip_id_index"
  add_index "sightings", ["species_id"], :name => "species_id_index"
  add_index "sightings", ["location_id"], :name => "location_id_index"

  create_table "species", :force => true do |t|
    t.column "abbreviation", :string
    t.column "latinname",    :string
    t.column "commonname",   :string
    t.column "notes",        :text
    t.column "referenceurl", :string
    t.column "abacountable", :integer, :limit => 2
  end

  create_table "states", :force => true do |t|
    t.column "name",         :string
    t.column "abbreviation", :string, :limit => 2
    t.column "notes",        :text
  end

  create_table "trips", :force => true do |t|
    t.column "leader",       :string
    t.column "referenceurl", :string
    t.column "name",         :string
    t.column "notes",        :text
    t.column "ignored",      :date
  end

end
