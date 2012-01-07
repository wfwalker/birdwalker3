class County < ActiveRecord::Base
  belongs_to :state
  
  has_many :locations do
    def with_lat_long
      Location.with_lat_long(self)
    end
  end
  
  has_many :sightings, :class_name => 'Sighting', :finder_sql => 'SELECT DISTINCT sightings.* FROM species, sightings, locations
    WHERE species.id=sightings.species_id AND sightings.location_id=locations.id
    AND sightings.exclude=false AND species.aba_countable=1
    AND locations.county_id=#{id}' do
    
    def earliest
      Sighting.earliest(self)
    end                      

    def latest
      Sighting.latest(self)
    end

    def life
      Sighting.first_per_species(self)
    end
  end
  
  has_many :species, :class_name => 'Species', :finder_sql => 'SELECT DISTINCT species.* FROM species, families, sightings, locations
    WHERE species.id=sightings.species_id AND species.family_id=families.id AND sightings.location_id=locations.id
    AND sightings.exclude=false AND species.aba_countable=1
    AND locations.county_id=#{id} ORDER BY families.taxonomic_sort_id, species.id'

  has_many :trips, :class_name => 'Trip', :finder_sql => 'SELECT DISTINCT trips.* FROM trips, sightings, locations
    WHERE trips.id=sightings.trip_id AND sightings.location_id=locations.id AND locations.county_id=#{id} ORDER BY trips.date' do   
    
    def earliest
      Trip.earliest(self)
    end                      

    def latest
      Trip.latest(self)
    end
  end
  
  has_many :photos, :through => :locations do
    def latest
      Photo.latest(self)
    end
  end
  
  has_many :gallery_photos, :through => :locations, :conditions => { :rating => [4,5] }
  
  validates_presence_of :name, :state
  
  # def to_param
  #   "#{id}-#{name.downcase.gsub(/[^[:alnum:]]/,'-').gsub(/-{2,}/,'-')}"
  # end

  def common?
    self.trips.length > 8
  end
    
  def full_name()
    self.name + " County"
  end

  def County.map_by_state(countyList)
   countyList.inject({}) { | map, county |
      map[county.state] ? map[county.state] << county : map[county.state] = [county] ; map }
  end  

  def year_span
    years = trips.collect {|trip| trip.date.year}
    return years.max - years.min + 1
  end
  
  def trips_per_year
    (self.trips.size.to_f / self.year_span.to_f).ceil 
  end
end
