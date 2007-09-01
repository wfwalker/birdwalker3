class CreateTrips < ActiveRecord::Migration
  def self.up
    create_table :trips do |t|
    end
  end

  def self.down
    drop_table :trips
  end
end
