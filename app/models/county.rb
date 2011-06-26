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

    def life
      # create triples of trip.date, species_id, and sighting object
      triples = self.collect{ |sighting| [sighting.trip.date, sighting.species_id, sighting] }.sort{ |x,y| x[0] <=>y[0] }
      # get a list of unique species_ids
      species_ids = self.collect{ |sighting| sighting.species_id }.uniq
      # use rassoc to find the first triple for each species_id
      firsts = species_ids.collect { |species_id| triples.rassoc(species_id) }
      # return the third item from the first triple for each species_id
      return firsts.collect { |triple| triple[2] }
    end
  end
  
  has_many :species, :class_name => 'Species', :finder_sql => 'SELECT DISTINCT species.* FROM species, families, sightings, locations
    WHERE species.id=sightings.species_id AND species.family_id=families.id AND sightings.location_id=locations.id
    AND locations.county_id=#{id} ORDER BY families.taxonomic_sort_id, species.id'

  has_many :trips, :class_name => 'Trip', :finder_sql => 'SELECT DISTINCT trips.* FROM trips, sightings, locations
    WHERE trips.id=sightings.trip_id AND sightings.location_id=locations.id AND locations.county_id=#{id} ORDER BY trips.date'
  
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
