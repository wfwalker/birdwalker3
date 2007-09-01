class CreateSpecies < ActiveRecord::Migration
  def self.up
    create_table :species do |t|
    end
  end

  def self.down
    drop_table :species
  end
end
