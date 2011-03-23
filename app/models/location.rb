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
  
  has_many :gallery_photos, :class_name => 'Photo', :conditions => { :rating => [4,5] }, :limit => Photo.default_gallery_size(), :order => 'trip_id DESC' # MOO THIS IS WRONG
  
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
    self.trips.size > 8
  end
  
  def abbreviation
    self.name.gsub(/[a-z' ]/,'')
  end
  
  def full_name
    self.name + ", " + self.county.state.abbreviation
  end
  
  def recent_nearby_ebird_sightings
    if self.longitude != 0
      recent_sightings_xml = EBird.get_XML('data/obs/geo/recent', {'lng' => self.longitude, 'lat' => self.latitude, 'dist' => 5, 'back' => 5})
      EBird.parse_XML_as_sightings(recent_sightings_xml)
    else
      []
    end
  end

  def recent_nearby_ebird_sightings_as_JSON
    if self.longitude != 0
      EBird.get_JSON('data/obs/geo/recent', {'lng' => self.longitude, 'lat' => self.latitude, 'dist' => 5, 'back' => 5})
    else
      ""
    end
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

