class Family < ActiveRecord::Base
  has_many :species
  
  def next
    Location.find(:first, :conditions => ["id > (?)", self.id.to_s], :order => 'id')
  end

  def previous
    Location.find(:first, :conditions => ["id < (?)", self.id.to_s], :order => 'id DESC')
  end
  
  # TODO: some cleaner way to do this!
  def Family.find_all_seen
    Family.find_by_sql "SELECT DISTINCT(families.id), families.* from families, species, sightings WHERE species.id=sightings.species_id AND species.family_id=families.id ORDER BY families.taxonomic_sort_id"
  end  
  
  def find_photo
    Sighting.find_by_sql "SELECT sightings.* FROM species, sightings WHERE sightings.photo='1' AND species.id=sightings.species_id AND species.family_id='" + self.id.to_s + "' ORDER BY sightings.id DESC LIMIT 1"
  end  

  def find_all_photos
    Sighting.find_by_sql "SELECT sightings.* FROM species, sightings WHERE sightings.photo='1' AND species.id=sightings.species_id AND species.family_id='" + self.id.to_s + "'"
  end  
  
  def find_all_species_seen
    Species.find_by_sql "SELECT DISTINCT(species.id), species.* from species, sightings WHERE species.id=sightings.species_id AND species.family_id='" + self.id.to_s + "' ORDER BY species.id"
  end
end
