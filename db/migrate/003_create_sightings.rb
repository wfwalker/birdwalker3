class CreateSightings < ActiveRecord::Migration
  def self.up
    create_table :sightings do |t|
    end
  end

  def self.down
    drop_table :sightings
  end
end
