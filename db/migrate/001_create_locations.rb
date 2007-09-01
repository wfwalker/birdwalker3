class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
    end
  end

  def self.down
    drop_table :locations
  end
end
