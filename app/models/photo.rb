class Photo < ActiveRecord::Base
  attr_accessible :trip_id, :location_id, :taxon_latin_name, :original_filename, :rating, :notes

  belongs_to :location
  belongs_to :trip
  has_one :taxon, :class_name => "Taxon", :foreign_key => "latin_name", :primary_key => "taxon_latin_name"

  validates_presence_of :taxon_latin_name, :location_id, :trip_id
  validates_uniqueness_of :original_filename, :scope => [:taxon_latin_name, :location_id, :trip_id]
  
  def Photo.default_gallery_size
      27
  end
  
  def image_base_URL(hostname)
    if (ENV['image_base_url'] != nil)
      ENV['image_base_url']
    elsif (hostname && hostname.length >= 1)
      "http://" + hostname + "/images"
    else
      "/images"
    end
  end      
  
  def Photo.this_week(photoList)
    photoList.select { |a_photo| a_photo.trip.date.cweek == Date.today.cweek }
  end     
  
  def Photo.latest(photoList)
    photoList.sort{|x,y| y.trip.date <=> x.trip.date}.first
  end
  
  def image_filename
    if self.original_filename != nil
      self.trip.date.to_s + "-" + self.taxon.abbreviation + "-" + self.original_filename + ".jpg"
    else                             
      self.trip.date.to_s + "-" + self.taxon.abbreviation + ".jpg"
    end
  end
    
  def photo_URL(hostname="")
    image_base_URL(hostname) + "/photo/" + image_filename
  end
  
  def thumb_URL(hostname="")
    image_base_URL(hostname) + "/thumb/" + image_filename
  end
  
  def thumb(hostname="")      
    ("<img border=\"0\" width=\"100\" height=\"100\" src=\"" + thumb_URL(hostname) + "\" />").html_safe
  end

  def photo(hostname="")     
    ("<img border=\"0\" src=\"" + photo_URL(hostname) + "\" />").html_safe
  end

  def Photo.map_by_location(photo_list)
    photo_list.inject({}) { | map, photo |
       map[Photo.location] ? map[Photo.location] << Photo : map[Photo.location] = [Photo] ; map }
  end
  
  def Photo.sort_taxonomic(photo_list)
    photo_list.sort_by { |s| s.taxon ? s.taxon.sort : 0 }
  end

  def Photo.sort_chronological(photo_list)
    photo_list.sort { |a, b| a.trip.date == b.trip.date ? a.location_id == b.location_id ? a.taxon.sort <=> b.taxon.sort : a.location_id <=> b.location_id : a.trip.date <=> b.trip.date }.reverse
  end
  
  def Photo.sort_alphabetic(photo_list)
    photo_list.sort_by { |s| s.taxon.common_name }
  end
  
  def Photo.map_by_family(photo_list)
    photo_list.inject({}) { | map, photo |
       map[photo.taxon.family] ? map[photo.taxon.family] << Photo : map[photo.taxon.family] = [Photo] ; map }
  end
  
  def Photo.recent(count)
    Photo.find_by_sql("select photos.* from photos, trips where photos.rating >=3 AND photos.trip_id=trips.id ORDER BY trips.date DESC LIMIT %d" % count)
  end
end
