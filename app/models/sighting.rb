class Sighting < ActiveRecord::Base
  belongs_to :location
  belongs_to :species
  belongs_to :trip
  
  validates_presence_of :species_id, :location_id, :trip_id
  
  def photoURL
    "http://sven.spflrc.org/~walker/images/photo/" + self.trip.date.to_s + "-" + self.species.abbreviation + ".jpg"
  end
  
  def thumbURL
    "http://sven.spflrc.org/~walker/images/thumb/" + self.trip.date.to_s + "-" + self.species.abbreviation + ".jpg"
  end
  
  def thumb
    "<img border=\"0\" width=\"100\" height=\"100\" src=\"" + thumbURL + "\"/>"
  end
  
  def Sighting.map_by_location(sightingList)
    logger.error("START map_by_location");
    sightingList.inject({}) { | map, sighting |
        logger.error("LOOP map_by_location");
       map[sighting.location_id] ? map[sighting.location_id] << sighting : map[sighting.location_id] = [sighting] ; map }
  end
end
