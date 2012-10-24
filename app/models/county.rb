class County < ActiveRecord::Base
  attr_accessible :name, :state_id
  
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
      Sighting.first_per_species(self)
    end
  end
  
  has_many :species, :through => :sightings, :uniq => true, :order => 'species.id'

  has_many :trips, :through => :sightings, :uniq => true do       
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
