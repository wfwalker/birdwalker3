class State < ActiveRecord::Base
  has_many :counties
  has_many :locations, :through => :counties
  
  def next
    State.find(:first, :conditions => ["name > (?)", self.name.to_s], :order => 'name')
  end

  def previous
    State.find(:first, :conditions => ["name < (?)", self.name.to_s], :order => 'name DESC')
  end
  
  def find_all_species
    Species.find_by_sql("SELECT DISTINCT species.* FROM species, sightings, locations, counties, states 
      WHERE species.id=sightings.species_id AND sightings.location_id=locations.id AND
      locations.county_id=counties.id AND counties.state_id='" + self.id.to_s + "' ORDER BY species.id")
  end
  
  def find_all_trips
    Trip.find_by_sql("SELECT DISTINCT trips.* FROM trips, sightings, locations, counties, states 
      WHERE trips.id=sightings.trip_id AND sightings.location_id=locations.id AND
      locations.county_id=counties.id AND counties.state_id='" + self.id.to_s + "' ORDER BY trips.id")
  end
  
  def find_all_photos
    Sighting.find_by_sql("SELECT DISTINCT sightings.* FROM sightings, locations, counties, states 
      WHERE sightings.photo='1' AND sightings.location_id=locations.id AND
      locations.county_id=counties.id AND counties.state_id='" + self.id.to_s + "' ORDER BY sightings.id")
  end
end
