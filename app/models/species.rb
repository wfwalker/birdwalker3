class Species < ActiveRecord::Base
  has_many :sightings
  has_many :trips, :through => :sightings, :select => "DISTINCT trips.*", :order => "trips.ignored DESC"
  has_many :locations, :through => :sightings, :select => "DISTINCT locations.*", :order => "locations.state, locations.county, locations.name"
  
  # TODO: some cleaner way to do this!
  def Species.find_all_seen
    Species.find_by_sql "SELECT DISTINCT(species.id), species.* from species, sightings WHERE species.id=sightings.species_id ORDER BY species.id"
  end
  
  def find_all_photos
    Sighting.find(:all, :conditions => ["species_id = " + self.id.to_s + " AND photo = 1"], :order => "date DESC")
  end
end
