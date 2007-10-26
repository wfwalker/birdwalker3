class Location < ActiveRecord::Base
  has_many :sightings
  has_one :first_sighting, :class_name => 'Sighting', :order => 'trip_id'
  has_one :last_sighting, :class_name => 'Sighting', :order => 'trip_id DESC'
  
  has_many :species, :through => :sightings, :select => "DISTINCT species.*", :order => "species.id"
  has_many :trips, :through => :sightings, :select => "DISTINCT trips.*", :order => "trips.date DESC"
  
  validates_presence_of :name, :county, :state
  
  def next
    Location.find(:first, :conditions => ["id > (?)", self.id.to_s], :order => 'county, state')
  end

  def previous
    Location.find(:first, :conditions => ["id < (?)", self.id.to_s], :order => 'county, state DESC')
  end
  
  def find_state
    State.find(:first, :conditions => ["abbreviation = (?)", self.state])
  end
  
  def find_all_photos
    Sighting.find(:all, :conditions => ["location_id = (?) AND photo = 1", self.id], :order => "trip_id DESC" )
  end
  
  def Location.map_by_state(locationList)
    locationList.inject({}) { | map, location |
       map[location.state] ? map[location.state] << location : map[location.state] = [location] ; map }
  end  
end

