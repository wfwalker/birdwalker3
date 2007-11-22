class Species < ActiveRecord::Base
  has_many :sightings
  has_one :first_sighting, :class_name => 'Sighting', :order => 'trip_id'
  has_one :last_sighting, :class_name => 'Sighting', :order => 'trip_id DESC'
  has_many :sightings_with_photos, :class_name => 'Sighting', :conditions => 'photo = 1'
  belongs_to :family
  
  has_many :trips, :through => :sightings, :select => "DISTINCT trips.*", :order => "trips.date DESC" do
    def map_by_year
      Trip.map_by_year(proxy_target)
    end
  end

  has_many :locations, :through => :sightings, :select => "DISTINCT locations.*", :order => "locations.county_id, locations.name" do
    def map_by_state
      Location.map_by_state(proxy_target)
    end  
  end
  
  validates_presence_of :common_name, :latin_name, :abbreviation

  def next
    Species.find(:first, :conditions => ["id > (?)", self.id.to_s], :order => 'id')
  end

  def previous
    Species.find(:first, :conditions => ["id < (?)", self.id.to_s], :order => 'id DESC')
  end
  
  # TODO: some cleaner way to do this!
  def Species.find_all_seen
    Species.find_by_sql "SELECT DISTINCT(species.id), species.* from species, sightings WHERE species.id=sightings.species_id"
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
end
