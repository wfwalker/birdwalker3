class Species < ActiveRecord::Base
  belongs_to :family
  
  has_many :sightings
  has_one :first_sighting, :class_name => 'Sighting', :conditions => 'exclude != 1', :order => 'trip_id'
  has_one :last_sighting, :class_name => 'Sighting', :conditions => 'exclude != 1', :order => 'trip_id DESC'
  has_many :sightings_with_photos, :class_name => 'Sighting', :conditions => 'photo = 1'
  
  has_many :trips, :through => :sightings, :select => "DISTINCT trips.*", :order => "trips.date DESC" do
  end

  has_many :locations, :through => :sightings, :select => "DISTINCT locations.*", :order => "locations.county_id, locations.name" do
    def with_lat_long
      Location.with_lat_long(self)
    end
  end
  
  validates_presence_of :common_name, :latin_name, :abbreviation

  def next
    Species.find(:first, :conditions => ["id > (?)", self.id.to_s], :order => 'id')
  end

  def previous
    Species.find(:first, :conditions => ["id < (?)", self.id.to_s], :order => 'id DESC')
  end

  def photo_of_the_week
    Sighting.find_by_sql("SELECT sightings.* FROM sightings, trips WHERE sightings.trip_id=trips.id AND sightings.photo='1' AND sightings.species_id=" + self.id.to_s + " AND WeekOfYear(trips.date)='" + Date.today.cweek.to_s + "' LIMIT 1")[0]
  end
  
  # TODO: some cleaner way to do this!
  def Species.find_all_seen
    Species.find_by_sql "SELECT DISTINCT(species.id), species.* from species, sightings, families WHERE species.id=sightings.species_id AND species.family_id=families.id ORDER BY families.taxonomic_sort_id"
  end  

  def Species.find_all_seen_not_excluded
    Species.find_by_sql "SELECT DISTINCT(species.id), species.* from species, sightings WHERE species.aba_countable='1' AND sightings.exclude!='1' AND species.id=sightings.species_id"
  end  

  def Species.find_all_photographed_not_excluded
    Species.find_by_sql "SELECT DISTINCT(species.id), species.* from species, sightings WHERE species.aba_countable='1' AND sightings.photo='1' AND sightings.exclude!='1' AND species.id=sightings.species_id"
  end  

  def Species.find_all_seen_by_common_name
    Species.find_by_sql "SELECT DISTINCT(species.id), species.* from species, sightings WHERE species.id=sightings.species_id ORDER BY species.common_name"
  end  
  
  def Species.map_by_family(species_list)
    species_list.inject({}) { | map, species |
       map[species.family] ? map[species.family] << species : map[species.family] = [species] ; map }
  end
  
  def Species.sort_taxonomic(species_list)
    species_list.sort_by { |s| s.family.taxonomic_sort_id * 100000000000 + s.id }
  end
  
  def Species.bird_of_the_week
    Species.find_by_sql("SELECT DISTINCT species.* FROM species, sightings, trips WHERE sightings.photo='1' AND sightings.species_id=species.id AND sightings.trip_id=trips.id AND WeekOfYear(trips.date)='" + Date.today.cweek.to_s + "' LIMIT 1")[0]
  end

  def Species.year_to_date(year)
    Species.find_by_sql("SELECT DISTINCT species.* FROM species, sightings, trips WHERE sightings.species_id=species.id AND sightings.trip_id=trips.id AND Year(trips.date)='" + year.to_s + "' AND WeekOfYear(trips.date)<='" + Date.today.cweek.to_s + "'")
  end
end
