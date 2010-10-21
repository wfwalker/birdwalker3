class County < ActiveRecord::Base
  belongs_to :state
  
  has_many :locations do
    def with_lat_long
      Location.with_lat_long(self)
    end
  end
  
  has_many :sightings, :through => :locations do
    def earliest
      Sighting.earliest(self)
    end                      

    def latest
      Sighting.latest(self)
    end
  end
  
  has_many :photos, :through => :locations do
    def latest
      Photo.latest(self)
    end
  end
  
  has_many :gallery_photos, :through => :locations, :conditions => { :rating => [4,5] }, :limit => 15, :order => 'id DESC'
  
  validates_presence_of :name, :state
  
  # def to_param
  #   "#{id}-#{name.downcase.gsub(/[^[:alnum:]]/,'-').gsub(/-{2,}/,'-')}"
  # end

  def common?
    self.trips.size > 8
  end
    
  def full_name()
    self.name + " County"
  end

 # do something like county.sightings.map(&:species).flatten.uniq
 # (Grab all of the sightings for the county, create a new array made up of all 
 #of the arrays of species associated with each sighting, flatten it into a 1-d array and remove dupes)
 # Which I would build into the sightings association using a block.    
 
 def County.map_by_state(countyList)
   countyList.inject({}) { | map, county |
      map[county.state] ? map[county.state] << county : map[county.state] = [county] ; map }
 end  

  def species
    Species.find_by_sql("SELECT DISTINCT species.* FROM species, sightings, locations WHERE species.id=sightings.species_id AND sightings.location_id=locations.id AND locations.county_id='" + self.id.to_s + "'")
  end

  def trips
    Trip.find_by_sql("SELECT DISTINCT trips.* FROM trips, sightings, locations WHERE trips.id=sightings.trip_id AND sightings.location_id=locations.id AND locations.county_id='" + self.id.to_s + "'")
  end
  
  def year_span
    years = trips.collect {|trip| trip.date.year}
    return years.max - years.min + 1
  end
  
  def trips_per_year
    (self.trips.size.to_f / self.year_span.to_f).ceil 
  end
end
