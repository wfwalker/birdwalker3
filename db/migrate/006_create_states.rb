class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.string "name",         :limit => 16
      t.string "abbreviation", :limit => 2
      t.text   "notes"
    end
  end

  def self.down
    drop_table :states
  end
end
