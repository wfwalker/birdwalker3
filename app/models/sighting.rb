class Sighting < ActiveRecord::Base
  belongs_to :location
  belongs_to :species
  belongs_to :trip
  before_validation :populate_old_fields
  
  validates_presence_of :species_id, :location_id, :trip_id, :oldspeciesabbrev
  
  def photoURL
    "http://sven.spflrc.org/~walker/images/photo/" + self.date.to_s + "-" + self.species.abbreviation + ".jpg"
  end
  
  def thumbURL
    "http://sven.spflrc.org/~walker/images/thumb/" + self.date.to_s + "-" + self.species.abbreviation + ".jpg"
  end
  
  def thumb
    "<img border=\"0\" width=\"100\" height=\"100\" src=\"" + thumbURL + "\"/>"
  end
  
  def populate_old_fields
    self.oldspeciesabbrev = self.species.abbreviation
    self.date = self.trip.ignored
    self.oldlocationname = self.location.name
  end
end
