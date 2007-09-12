class Trip < ActiveRecord::Base
  has_many :sightings
  has_many :species, :through => :sightings, :select => "DISTINCT species.*", :order => "species.id"
  has_many :locations, :through => :sightings, :select => "DISTINCT locations.*", :order => "locations.state, locations.county, locations.name"
  
  validates_presence_of :name
  
  def find_all_photos
    Sighting.find(:all, :conditions => ["trip_id = " + self.id.to_s + " AND photo = 1"], :order => "date DESC")
  end
  
  def Trip.map_by_year(tripList)
    map = Hash.new
    
    tripList.inject({}) { | map, trip |
       map[trip.ignored.year] ? map[trip.ignored.year] << trip : map[trip.ignored.year] = [trip] ; map }
  end
end
