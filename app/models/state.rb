class State < ActiveRecord::Base
  has_many :counties
  has_many :locations, :through => :counties do
    def with_lat_long
      Location.with_lat_long(self)
    end
  end
  
  # def to_param
  #   "#{id}-#{name.downcase.gsub(/[^[:alnum:]]/,'-').gsub(/-{2,}/,'-')}"
  # end

  def species
    Species.find_by_sql("SELECT DISTINCT species.* FROM species, sightings, locations, counties 
      WHERE species.id=sightings.species_id AND sightings.location_id=locations.id AND
      locations.county_id=counties.id AND counties.state_id='" + self.id.to_s + "'")
  end
  
  def trips
    Trip.find_by_sql("SELECT DISTINCT trips.* FROM trips, sightings, locations, counties 
      WHERE trips.id=sightings.trip_id AND sightings.location_id=locations.id AND
      locations.county_id=counties.id AND counties.state_id='" + self.id.to_s + "'")
  end

  def sightings
    Sighting.find_by_sql("SELECT DISTINCT sightings.* FROM sightings, locations, counties 
      WHERE sightings.location_id=locations.id AND
      locations.county_id=counties.id AND counties.state_id='" + self.id.to_s + "' ORDER BY sightings.id")
  end
  
  def photos
    Photo.find_by_sql("SELECT DISTINCT photos.* FROM photos, locations, counties 
      WHERE photos.location_id=locations.id AND
      locations.county_id=counties.id AND counties.state_id='" + self.id.to_s + "' ORDER BY photos.id")
  end
  
  def State.sort_alphabetic(state_list)
    state_list.sort_by { |s| s.name }
  end
end
