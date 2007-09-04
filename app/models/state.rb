class State < ActiveRecord::Base
  def find_all_locations
    @locations = Location.find(:all, :conditions => ["State = ?", self.abbreviation], :order => "locations.state, locations.county")
  end

  def find_all_species
    Species.find_by_sql("SELECT DISTINCT species.* FROM species, sightings, locations WHERE species.id=sightings.species_id AND sightings.location_id=locations.id AND locations.state='" + self.abbreviation + "' ORDER BY species.id")
  end
  
  def find_all_trips
    Trip.find_by_sql("SELECT DISTINCT trips.* FROM trips, sightings, locations WHERE trips.id=sightings.trip_id AND sightings.location_id=locations.id AND locations.state='" + self.abbreviation + "' ORDER BY trips.ignored DESC")
  end
  
  def find_all_photos
    Sighting.find_by_sql("SELECT sightings.* FROM sightings, locations WHERE sightings.photo='1' AND sightings.location_id=locations.id AND locations.state='" + self.abbreviation + "' ORDER BY sightings.date DESC LIMIT 50")
  end
end
