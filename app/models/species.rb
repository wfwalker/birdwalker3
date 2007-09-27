class Species < ActiveRecord::Base
  has_many :sightings
  has_one :first_sighting, :class_name => 'Sighting', :order => 'date'
  has_one :last_sighting, :class_name => 'Sighting', :order => 'date DESC'
  
  has_many :trips, :through => :sightings, :select => "DISTINCT trips.*", :order => "trips.ignored DESC"
  has_many :locations, :through => :sightings, :select => "DISTINCT locations.*", :order => "locations.state, locations.county, locations.name"
  
  validates_presence_of :commonname, :latinname, :abbreviation
  
  # TODO: some cleaner way to do this!
  def Species.find_all_seen
    Species.find_by_sql "SELECT DISTINCT(species.id), species.* from species, sightings WHERE species.id=sightings.species_id ORDER BY species.id"
  end
  
  def find_all_photos
    Sighting.find(:all, :conditions => ["species_id = " + self.id.to_s + " AND photo = 1"], :order => "date DESC")
  end
end
