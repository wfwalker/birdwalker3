class CreateCounties < ActiveRecord::Migration
  def self.up
    create_table :counties do |t|
      t.text    "name",     :limit => 255
      t.integer "state_id"
    end
  end

  def self.down
    drop_table :counties
  end
end
