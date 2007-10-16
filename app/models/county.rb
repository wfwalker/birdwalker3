class County < ActiveRecord::Base
  attr_accessor :name
  attr_accessor :locations
  
  def initialize(name)
    @name = name
    @locations = Location.find(:all, :conditions => ["County = ?", @name])
  end
  
  def find_all_species
    @species = Species.find_by_sql("SELECT DISTINCT species.* FROM species, sightings, locations WHERE species.id=sightings.species_id AND sightings.location_id=locations.id AND locations.county='" + self.name + "' ORDER BY species.id")
  end

  def find_all_trips
    Trip.find_by_sql("SELECT DISTINCT trips.* FROM trips, sightings, locations WHERE trips.id=sightings.trip_id AND sightings.location_id=locations.id AND locations.county='" + self.name + "'ORDER BY trips.date DESC")
  end

  def find_all_photos
    Sighting.find_by_sql("SELECT sightings.* FROM sightings, locations WHERE sightings.photo='1' AND sightings.location_id=locations.id AND locations.county='" + self.name + "' ORDER BY sightings.trip_id DESC LIMIT 50")
  end
end
