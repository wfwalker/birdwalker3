class Location < ActiveRecord::Base
  has_many :sightings
  has_many :species, :through => :sightings, :select => "DISTINCT species.*", :order => "species.id"
  has_many :trips, :through => :sightings, :uniq => true
  
  def find_all_photos
    Sighting.find(:all, :conditions => ["location_id = " + self.id.to_s + " AND photo = 1"])
  end
end

