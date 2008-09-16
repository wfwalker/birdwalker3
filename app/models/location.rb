class Location < ActiveRecord::Base
  has_many :sightings
  has_many :photos
  has_many :gallery_photos, :class_name => 'Photo', :conditions => { :rating => [4,5] }
  has_one :first_sighting, :class_name => 'Sighting', :order => 'trip_id'
  has_one :last_sighting, :class_name => 'Sighting', :order => 'trip_id DESC'   # MOOO THIS IS WRONG
  belongs_to :county
  
  has_many :species, :through => :sightings, :select => "DISTINCT species.*" do
    def map_by_family
      Species.map_by_family(proxy_target)
    end  
  end
  
  has_many :trips, :through => :sightings, :select => "DISTINCT trips.*", :order => "trips.date DESC" do
    def map_by_year
      Trip.map_by_year(proxy_target)
    end
  end      
  
  validates_presence_of :name, :county  
  
  def common?
    self.trips.size > 8
  end
  
  def abbreviation
    self.name.gsub(/[a-z' ]/,'')
  end

  def Location.map_by_state(locationList)
    locationList.inject({}) { | map, location |
       map[location.county.state] ? map[location.county.state] << location : map[location.county.state] = [location] ; map }
  end  
  
  def Location.with_lat_long(locationList)
    locationList.select { | location |
      location.latitude != 0 && location.longitude != 0 }
  end 
  
  def Location.most_visited
    Location.find_by_sql("select locations.*, count(distinct trips.id) as trip_count from locations,sightings,trips where locations.id=sightings.location_id and sightings.trip_id=trips.id group by locations.id order by trip_count desc limit 10");
  end
                               
  def Location.most_visited_recently
    Location.find_by_sql("select locations.*, count(distinct trips.id) as trip_count from locations,sightings,trips where locations.id=sightings.location_id and sightings.trip_id=trips.id and datediff(now(), trips.date) < 40 group by locations.id order by trip_count desc limit 5");
  end
  
  def Location.find_by_county_and_state
    Location.find_by_sql("SELECT DISTINCT locations.* from locations, counties, states where locations.county_id=counties.id AND counties.state_id = states.id ORDER BY states.name, locations.name")
  end     
end

