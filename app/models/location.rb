require 'sun_times'

class Location < ActiveRecord::Base
  belongs_to :county

  has_many :sightings do
    def earliest
      Sighting.earliest(self)
    end                      

    def latest
      Sighting.latest(self)
    end
  end

  has_many :photos do
    def latest
      Photo.latest(self)
    end
  end
  
  has_many :gallery_photos, :class_name => 'Photo', :conditions => { :rating => [4,5] }
  
# TODO: should be sorted by families.taxonomic_sort_id first  
  has_many :species, :through => :sightings, :order => 'species.id', :uniq => true do
    def map_by_family
      load_target
      Species.map_by_family(proxy_target)
    end  
  end
  
  has_many :trips, :through => :sightings, :uniq => true, :order => "trips.date DESC" do
    def map_by_year
      load_target
      Trip.map_by_year(proxy_target)
    end
  end      
  
  validates_presence_of :name, :county  
  
  def common?
    self.trips.length > 8
  end
  
  def abbreviation
    self.name.gsub(/[a-z' ]/,'')
  end
  
  def full_name
    self.name + ", " + self.county.state.abbreviation
  end
  
  def recent_nearby_ebird_sightings(in_dist = 5)
    if self.longitude != 0
      EBird.get_JSON('data/obs/geo/recent', {'lng' => self.longitude, 'lat' => self.latitude, 'dist' => in_dist, 'back' => 5 })
    else
      ""
    end
  end   
  
  def sunrise(in_date = Date.today)     
    if self.latitude != 0.0
      return SunTimes.rise(in_date, self.latitude, self.longitude)
    else
      nil
    end
  end

  def sunset(in_date = Date.today)  
    if self.latitude != 0.0
      return SunTimes.set(in_date, self.latitude, self.longitude)
    else
      nil
    end
  end
  
  def distance_in_miles_from(another_location)  
    # answer found at http://stackoverflow.com/questions/365826/calculate-distance-between-2-gps-coordinates
    # Apparently this is known as Haversize computation
    degrees_to_radians = (Math::PI / 180.0)

    difference_in_longitude = (another_location.longitude - self.longitude) * degrees_to_radians;
    difference_in_latitude = (another_location.latitude - self.latitude) * degrees_to_radians;
    
    a = (Math.sin(difference_in_latitude/2.0) ** 2) + Math.cos(self.latitude*degrees_to_radians) * Math.cos(another_location.latitude * degrees_to_radians) * (Math.sin(difference_in_longitude/2.0) ** 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    d = 3956 * c; 
  end  
  
  def nearby_locations(miles_radius)
    Location.find(:all).select { | a_location | self.distance_in_miles_from(a_location) < miles_radius }
  end
  
  def Location.locations_near(in_lat, in_long, miles_radius)
    temp_location = Location.new
    temp_location.latitude = in_lat
    temp_location.longitude = in_long  
    
    temp_location.nearby_locations(miles_radius)
  end

  # def to_param
  #   "#{id}-#{name.downcase.gsub(/[^[:alnum:]]/,'-').gsub(/-{2,}/,'-')}"
  # end

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

