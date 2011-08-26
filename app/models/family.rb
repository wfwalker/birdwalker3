class Family < ActiveRecord::Base
  has_many :species
  
  has_many :sightings, :through => :species do
    def earliest
      Sighting.earliest(self)
    end                      

    def latest
      Sighting.latest(self)
    end
  end
  
  has_many :photos, :through =>:species do    
    def latest
      Photo.latest(self)
    end
  end
  
  has_many :gallery_photos, :through => :species, :conditions => { :rating => [4,5] }
  
  def common?
    self.sightings.length > 30
  end
  
  def species_seen
    Species.find_by_sql("SELECT DISTINCT species.* FROM species, sightings WHERE sightings.species_id=species.id AND species.family_id='" + self.id.to_s + "' ORDER BY species.id")
  end
  
  # TODO: some cleaner way to do this!
  def Family.find_all_seen
    Family.find_by_sql "SELECT DISTINCT(families.id), families.* from families, species, sightings WHERE species.id=sightings.species_id AND species.family_id=families.id ORDER BY families.taxonomic_sort_id"
  end  
  
  def Family.find_all_photographed
    Family.find_by_sql(
      "SELECT DISTINCT(families.id), families.* FROM species, families, photos
         WHERE species.id=photos.species_id AND species.family_id=families.id
         ORDER BY families.taxonomic_sort_id, photos.species_id")
  end  

  def first_sighting
    Sighting.find_by_sql(
      "SELECT * FROM sightings, species, trips
        WHERE sightings.species_id=species.id AND sightings.trip_id=trips.id AND species.family_id='" + self.id.to_s + "'
        ORDER BY trips.date limit 1")[0]
  end

  def last_sighting
    Sighting.find_by_sql(
      "SELECT * FROM sightings, species, trips
        WHERE sightings.species_id=species.id AND sightings.trip_id=trips.id AND species.family_id='" + self.id.to_s + "'
        ORDER BY trips.date DESC limit 1")[0]
  end
  
  def locations
    Location.find_by_sql(
      "SELECT DISTINCT locations.* from species, locations, sightings
        WHERE species.id=sightings.species_id AND sightings.location_id=locations.id AND species.family_id='" + self.id.to_s + "'
        ORDER BY locations.name")
  end  

  def trips
    Trip.find_by_sql "SELECT DISTINCT trips.* from trips, species, sightings WHERE trips.id=sightings.trip_id AND sightings.species_id=species.id AND species.family_id='" + self.id.to_s + "' ORDER BY trips.date"
  end    
  
  def Family.sort_taxonomic(family_list)
    family_list.sort_by { |f| f.taxonomic_sort_id }
  end
end
