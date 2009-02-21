class Species < ActiveRecord::Base
  belongs_to :family
                     
  # a Species has many sightings, including a first and last one                     
  has_many :sightings
  has_one :first_sighting, :class_name => 'Sighting', :conditions => 'exclude != 1', :order => 'trip_id'
  has_one :last_sighting, :class_name => 'Sighting', :conditions => 'exclude != 1', :order => 'trip_id DESC'
                                 
  # a Species has many photos, including 'gallery' (best quality) photos
  has_many :photos
  has_many :gallery_photos, :class_name => 'Photo', :conditions => { :rating => [4,5] }
    
  # trip-related assocations
  has_many :trips, :through => :sightings, :uniq => true, :order => "trips.date DESC"
                          
  # different species lists
  named_scope :seen, :include => [ :sightings, :family ], :conditions => [ 'sightings.species_id = species.id' ], :order => 'families.taxonomic_sort_id, species.id'         
  named_scope :photographed, :include => [ :photos, :family ], :conditions => [ 'photos.species_id = species.id' ], :order => 'families.taxonomic_sort_id, species.id'
  named_scope :seen_not_excluded, :include => [ :sightings, :family ], :conditions => [ 'sightings.exclude = false' ], :order => 'families.taxonomic_sort_id, species.id'  
  named_scope :countable, :include => :family, :conditions => [ 'species.aba_countable = true' ], :order => 'families.taxonomic_sort_id, species.id'  
  named_scope :seen_during, lambda { |year| { :include => [ :trips, :family ], :conditions => [ 'year(trips.date) = ?', year ], :order => 'families.taxonomic_sort_id, species.id' } }  
                                                                            
  # location-related associations
  has_many :locations, :through => :sightings, :uniq => true, :order => "locations.county_id, locations.name" do
    def with_lat_long
      Location.with_lat_long(self)
    end
  end
  
  validates_presence_of :common_name, :latin_name, :abbreviation    
  
  def common?
    self.sightings.size > 30
  end

  def photo_of_the_week
    Photo.find_by_sql(
      "SELECT photos.* FROM photos, trips
         WHERE photos.trip_id=trips.id AND photos.species_id=" + self.id.to_s + "
         AND WeekOfYear(trips.date)='" + Date.today.cweek.to_s + "' LIMIT 1")[0]
  end
  
  def Species.find_all_not_photographed
    Species.find_by_sql(
    "SELECT DISTINCT(species.id), species.* from species, sightings, families 
       WHERE species.id=sightings.species_id AND species.family_id=families.id AND species.aba_countable=1
       AND NOT EXISTS (select species_id from photos WHERE species.id=photos.species_id)
       ORDER BY families.taxonomic_sort_id, species.id")
  end  

  def Species.find_all_seen_by_common_name
    Species.find_by_sql("SELECT DISTINCT(species.id), species.* FROM species, sightings WHERE species.id=sightings.species_id ORDER BY species.common_name")
  end  
  
  def Species.map_by_family(species_list)
    species_list.inject({}) { | map, species |
       map[species.family] ? map[species.family] << species : map[species.family] = [species] ; map }
  end
  
  def Species.sort_taxonomic(species_list)
    species_list.sort_by { |s| s.family.taxonomic_sort_id * 100000000000 + s.id }
  end
  
  def Species.bird_of_the_week
    Species.find_by_sql("SELECT DISTINCT species.* FROM species, photos, trips
      WHERE photos.species_id=species.id AND photos.trip_id=trips.id
      AND WeekOfYear(trips.date)='" + Date.today.cweek.to_s + "'
      ORDER BY trips.date DESC LIMIT 1")[0]
  end

  def Species.year_to_date(year)  
    Species.find_by_sql(
      "SELECT DISTINCT species.* FROM species, sightings, trips
         WHERE sightings.species_id=species.id AND sightings.trip_id=trips.id AND Year(trips.date)='" + year.to_s + "' 
         AND WeekOfYear(trips.date)<='" + Date.today.cweek.to_s + "'")
  end
end
