class Trip < ActiveRecord::Base
  has_many :sightings
  has_many :species, :through => :sightings, :select => "DISTINCT species.*", :order => "species.id"
  
  has_many :locations, :through => :sightings, :select => "DISTINCT locations.*", :order => "locations.state, locations.county, locations.name" do
    def map_by_state
      proxy_target.inject({}) { | map, location |
         map[location.state] ? map[location.state] << location : map[location.state] = [location] ; map }
    end  
  end
  
  validates_presence_of :name
  
  def find_all_photos
    Sighting.find(:all, :conditions => ["trip_id = " + self.id.to_s + " AND photo = 1"], :order => "date DESC")
  end
  
  def Trip.map_by_year(tripList)
    tripList.inject({}) { | map, trip |
       map[trip.ignored.year] ? map[trip.ignored.year] << trip : map[trip.ignored.year] = [trip] ; map }
  end
end
