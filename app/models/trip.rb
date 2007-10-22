class Trip < ActiveRecord::Base
  has_many :sightings
  has_many :species, :through => :sightings, :select => "DISTINCT species.*", :order => "species.id"
  
  has_many :locations, :through => :sightings, :select => "DISTINCT locations.*", :order => "locations.state, locations.county, locations.name" do
    def map_by_state
      Location.map_by_state(proxy_target)
    end  
  end
  
  validates_presence_of :name, :date, :leader
  
  def find_all_photos
    Sighting.find(:all, :conditions => ["trip_id = " + self.id.to_s + " AND photo = 1"], :order => "species_id")
  end
  
  def Trip.map_by_year(tripList)
    tripList.inject({}) { | map, trip |
       map[trip.date.year] ? map[trip.date.year] << trip : map[trip.date.year] = [trip] ; map }
  end
end
