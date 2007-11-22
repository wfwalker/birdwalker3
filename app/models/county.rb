class County < ActiveRecord::Base
  belongs_to :state
  has_many :locations
  has_many :sightings, :through => :locations
  has_many :sightings_with_photos, :through => :locations, :conditions => 'sightings.photo = 1'
  
 # do something like county.sightings.map(&:species).flatten.uniq
 # (Grab all of the sightings for the county, create a new array made up of all 
 #of the arrays of species associated with each sighting, flatten it into a 1-d array and remove dupes)
 # Which I would build into the sightings association using a block.
  
  def next
    County.find(:first, :conditions => ["id > (?)", self.id.to_s], :order => 'id')
  end

  def previous
    County.find(:first, :conditions => ["id < (?)", self.id.to_s], :order => 'id DESC')
  end
  
  def species
    @species = Species.find_by_sql("SELECT DISTINCT species.* FROM species, sightings, locations WHERE species.id=sightings.species_id AND sightings.location_id=locations.id AND locations.county_id='" + self.id.to_s + "'")
  end

  def trips
    Trip.find_by_sql("SELECT DISTINCT trips.* FROM trips, sightings, locations WHERE trips.id=sightings.trip_id AND sightings.location_id=locations.id AND locations.county_id='" + self.id.to_s + "'")
  end
end
