class CreateCounties < ActiveRecord::Migration
  def self.up
    create_table :counties do |t|
    end
  end

  def self.down
    drop_table :counties
  end
end
