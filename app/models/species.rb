class Species < ActiveRecord::Base
  has_many :sightings
  has_many :trips, :through => :sightings, :uniq => true
  has_many :locations, :through => :sightings, :uniq => true
  
  # TODO: some cleaner way to do this!
  def Species.find_all_seen
    Species.find_by_sql "SELECT DISTINCT(species.id), species.* from species, sightings WHERE species.id=sightings.species_id ORDER BY species.id"
  end
  
  def find_all_photos
    Sighting.find(:all, :conditions => ["species_id = " + self.id.to_s + " AND photo = 1"])
  end
end
