class Location < ActiveRecord::Base
  has_many :sightings
  has_many :sightings_with_photos, :class_name => 'Sighting', :conditions => 'photo = 1'
  has_one :first_sighting, :class_name => 'Sighting', :order => 'trip_id'
  has_one :last_sighting, :class_name => 'Sighting', :order => 'trip_id DESC'
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
  
  def next
    Location.find(:first, :conditions => ["id > (?)", self.id.to_s], :order => 'county_id')
  end

  def previous
    Location.find(:first, :conditions => ["id < (?)", self.id.to_s], :order => 'county_id DESC')
  end
      
  def Location.map_by_state(locationList)
    locationList.inject({}) { | map, location |
       map[location.county.state] ? map[location.county.state] << location : map[location.county.state] = [location] ; map }
  end  
end

