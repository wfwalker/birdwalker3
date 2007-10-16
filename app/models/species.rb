class Species < ActiveRecord::Base
  has_many :sightings
  has_one :first_sighting, :class_name => 'Sighting', :order => 'trip_id'
  has_one :last_sighting, :class_name => 'Sighting', :order => 'trip_id DESC'
  
  has_many :trips, :through => :sightings, :select => "DISTINCT trips.*", :order => "trips.date DESC" do
    def map_by_year
      Trips.map_by_year(proxy_target)
    end
  end

  has_many :locations, :through => :sightings, :select => "DISTINCT locations.*", :order => "locations.state, locations.county, locations.name" do
    def map_by_state
      Location.map_by_state(proxy_target)
    end  
  end
  
  validates_presence_of :commonname, :latinname, :abbreviation

  def find_all_photos
    Sighting.find(:all, :conditions => ["species_id = " + self.id.to_s + " AND photo = 1"], :order => "trip_id DESC")
  end
  
  # TODO: some cleaner way to do this!
  def Species.find_all_seen
    Species.find_by_sql "SELECT DISTINCT(species.id), species.* from species, sightings WHERE species.id=sightings.species_id ORDER BY species.id"
  end  
end
