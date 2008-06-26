class Photo < ActiveRecord::Base
  belongs_to :location
  belongs_to :species
  belongs_to :trip
  
  validates_presence_of :species_id, :location_id, :trip_id
  
  def next
    Photo.find(:first, :conditions => ["id > (?)", self.id.to_s], :order => 'id')
  end

  def previous
    Photo.find(:first, :conditions => ["id < (?)", self.id.to_s], :order => 'id DESC')
  end
  
  def photoURL
    if (`hostname`.strip == "vermillion.local")
      "http://localhost/~walker/birdwalker2/images/photo/" + self.trip.date.to_s + "-" + self.species.abbreviation + ".jpg"
    else
      "http://www.spflrc.org/~walker/images/photo/" + self.trip.date.to_s + "-" + self.species.abbreviation + ".jpg"
    end
  end
  
  def thumbURL
    if (`hostname`.strip == "vermillion.local")
      "http://localhost/~walker/birdwalker2/images/thumb/" + self.trip.date.to_s + "-" + self.species.abbreviation + ".jpg"
    else
      "http://www.spflrc.org/~walker/images/thumb/" + self.trip.date.to_s + "-" + self.species.abbreviation + ".jpg"
    end
  end
  
  def thumb      
    "<img border=\"0\" width=\"100\" height=\"100\" src=\"" + thumbURL + "\"/>"
  end

  def tiny_thumb
    "<img border=\"0\" width=\"50\" height=\"50\" src=\"" + thumbURL + "\"/>"
  end
  
  def Photo.map_by_location(photo_list)
    photo_list.inject({}) { | map, photo |
       map[Photo.location] ? map[Photo.location] << Photo : map[Photo.location] = [Photo] ; map }
  end
  
  def Photo.sort_taxonomic(photo_list)
    photo_list.sort_by { |s| s.species ? s.species.family.taxonomic_sort_id * 100000000000 + s.species_id : 0 }
  end

  def Photo.sort_chronological(photo_list)
    photo_list.sort { |a, b| a.trip.date == b.trip.date ? a.location_id == b.location_id ? a.species_id <=> b.species_id : a.location_id <=> b.location_id : a.trip.date <=> b.trip.date }.reverse
  end
  
  def Photo.sort_alphabetic(photo_list)
    photo_list.sort_by { |s| s.species.common_name }
  end
  
  def Photo.map_by_family(photo_list)
    photo_list.inject({}) { | map, photo |
       map[photo.species.family] ? map[photo.species.family] << Photo : map[photo.species.family] = [Photo] ; map }
  end
end
