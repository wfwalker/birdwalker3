class Photo < ActiveRecord::Base
  belongs_to :location
  belongs_to :species
  belongs_to :trip
  
  validates_presence_of :species_id, :location_id, :trip_id
  
  def image_base_URL
    if (ENV['image_base_url'] != nil)
      ENV['image_base_url']
    else
      "/images"
    end
  end
    
  def photoURL
    image_base_URL + "/photo/" + self.trip.date.to_s + "-" + self.species.abbreviation + ".jpg"
  end
  
  def thumbURL
    image_base_URL + "/photo/" + self.trip.date.to_s + "-" + self.species.abbreviation + ".jpg"
  end
  
  def thumb      
    "<img border=\"0\" width=\"100\" height=\"100\" src=\"" + thumbURL + "\"/>"
  end

  def tiny_thumb
    "<img border=\"0\" width=\"75\" height=\"75\" src=\"" + thumbURL + "\"/>"
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
  
  def Photo.find_recent_gallery
    Photo.find_by_sql("select photos.* from photos, trips where photos.rating >=4 AND photos.trip_id=trips.id ORDER BY trips.date DESC LIMIT 10")
  end
end
