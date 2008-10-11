class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
    end
  end

  def self.down
    drop_table :photos
  end
end
