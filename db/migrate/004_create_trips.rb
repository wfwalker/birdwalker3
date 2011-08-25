class CreateTrips < ActiveRecord::Migration
  def self.up
    create_table :trips do |t|
      t.text "leader"
      t.text "reference_url"
      t.text "name"
      t.text "notes"
      t.date "date"
    end

    add_index "trips", ["date"], :name => "dateIndex"
  end

  def self.down
    drop_table :trips
  end
end
