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
  
  # TODO: some cleaner way to do this!
  def Family.find_all_seen
    Family.find_by_sql "SELECT DISTINCT(families.id), families.* from families, species, sightings WHERE species.id=sightings.species_id AND species.family_id=families.id ORDER BY families.taxonomic_sort_id"
  end  
  
  def find_all_species_seen
    Species.find_by_sql "SELECT DISTINCT(species.id), species.* from species, sightings WHERE species.id=sightings.species_id AND species.family_id='" + self.id.to_s + "' ORDER BY species.id"
  end
end
