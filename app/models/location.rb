class Location < ActiveRecord::Base
  has_many :sightings
  has_many :species, :through => :sightings, :select => "DISTINCT species.*", :order => "species.id"
  has_many :trips, :through => :sightings, :select => "DISTINCT trips.*", :order => "trips.ignored DESC"
  
  def find_all_photos
    Sighting.find(:all, :conditions => ["location_id = " + self.id.to_s + " AND photo = 1"], :order => "date DESC" )
  end
end

