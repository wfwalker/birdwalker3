class Family < ActiveRecord::Base
  has_many :species
  has_many :sightings, :through => :species
  has_many :sightings_with_photos, :through =>:species, :conditions => 'photo = 1'
  
  def next
    Location.find(:first, :conditions => ["id > (?)", self.id.to_s], :order => 'id')
  end

  def previous
    Location.find(:first, :conditions => ["id < (?)", self.id.to_s], :order => 'id DESC')
  end
  
  def species_seen
    Species.find_by_sql("SELECT DISTINCT species.* FROM species, sightings WHERE sightings.species_id=species.id AND species.family_id='" + self.id.to_s + "'")
  end
  
  # TODO: some cleaner way to do this!
  def Family.find_all_seen
    Family.find_by_sql "SELECT DISTINCT(families.id), families.* from families, species, sightings WHERE species.id=sightings.species_id AND species.family_id=families.id ORDER BY families.taxonomic_sort_id"
  end  

  def locations
    Location.find_by_sql "SELECT DISTINCT locations.* from species, locations, sightings WHERE species.id=sightings.species_id AND sightings.location_id=locations.id AND species.family_id='" + self.id.to_s + "' ORDER BY locations.name"
  end  

  def trips
    Trip.find_by_sql "SELECT DISTINCT trips.* from trips, species, sightings WHERE trips.id=sightings.trip_id AND sightings.species_id=species.id AND species.family_id='" + self.id.to_s + "' ORDER BY trips.date"
  end    
  
  def Family.sort_taxonomic(family_list)
    family_list.sort_by { |f| f.taxonomic_sort_id }
  end
end
