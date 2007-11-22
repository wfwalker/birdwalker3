class Sighting < ActiveRecord::Base
  belongs_to :location
  belongs_to :species
  belongs_to :trip
  
  validates_presence_of :species_id, :location_id, :trip_id
  
  def next
    Sighting.find(:first, :conditions => ["id > (?)", self.id.to_s], :order => 'id')
  end

  def previous
    Sighting.find(:first, :conditions => ["id < (?)", self.id.to_s], :order => 'id DESC')
  end
  
  def photoURL
    "http://www.spflrc.org/~walker/images/photo/" + self.trip.date.to_s + "-" + self.species.abbreviation + ".jpg"
  end
  
  def thumbURL
    "http://www.spflrc.org/~walker/images/thumb/" + self.trip.date.to_s + "-" + self.species.abbreviation + ".jpg"
  end
  
  def thumb
    "<img border=\"0\" width=\"100\" height=\"100\" src=\"" + thumbURL + "\"/>"
  end
  
  def Sighting.map_by_location(sighting_list)
    sighting_list.inject({}) { | map, sighting |
       map[sighting.location] ? map[sighting.location] << sighting : map[sighting.location] = [sighting] ; map }
  end
  
  def Sighting.sort_taxonomic(sighting_list)
    sighting_list.sort_by { |s| s.species.family.taxonomic_sort_id * 100000000000 + s.species_id }
  end
  
  def Sighting.sort_alphabetic(sighting_list)
    sighting_list.sort_by { |s| s.species.common_name }
  end
end
