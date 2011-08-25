class Species < ActiveRecord::Base
  belongs_to :family
                     
  # a Species has many sightings, including a first and last one                     
  has_many :sightings do
    def earliest
      Sighting.earliest(self)
    end                      

    def latest
      Sighting.latest(self)
    end
  end
                                 
  # a Species has many photos, including 'gallery' (best quality) photos
  has_many :photos do
    # Returns photos of this Species taken during the current week-of-the-year
    def this_week
      Photo.this_week(self)
    end  
    
    def latest
      Photo.latest(self)
    end
  end
  has_many :gallery_photos, :class_name => 'Photo', :conditions => { :rating => [4,5] }     
    
  # trip-related assocations
  has_many :trips, :through => :sightings, :uniq => true, :order => "trips.date DESC" do
    
    def earliest
      Trip.earliest(self)
    end                      

    def latest
      Trip.latest(self)
    end
  end
                          
  # different species lists
  named_scope :seen, :include => [ :sightings, :family ], :conditions => [ 'sightings.species_id = species.id' ], :order => 'families.taxonomic_sort_id, species.id'         
  named_scope :seen_by_common_name, :include => [ :sightings, :family ], :conditions => [ 'sightings.species_id = species.id' ], :order => 'species.common_name'         
  named_scope :photographed, :include => [ :photos, :family ], :conditions => [ 'photos.species_id = species.id' ], :order => 'families.taxonomic_sort_id, species.id'
  named_scope :seen_not_excluded, :include => [ :sightings, :family ], :conditions => [ 'sightings.exclude = false' ], :order => 'families.taxonomic_sort_id, species.id'  
  named_scope :countable, :conditions => [ 'species.aba_countable = true' ], :include => :family, :order => 'families.taxonomic_sort_id, species.id'  
  named_scope :seen_not_excluded_during, lambda { |year| { :include => [ :trips, :sightings, :family ], :conditions => [ 'sightings.exclude=false AND year(trips.date) = ?', year ], :order => 'families.taxonomic_sort_id, species.id' } }  
  named_scope :seen_in_county, lambda { |county_id| { :include => [ :locations, :family ], :conditions => [ 'year(locations.county_id) = ?', year ], :order => 'families.taxonomic_sort_id, species.id' } }  
                                                                            
  # location-related associations
  has_many :locations, :through => :sightings, :uniq => true, :order => "locations.county_id, locations.name" do
    # Returns the list of locations for which we have latitude and longitude
    def with_lat_long
      Location.with_lat_long(self)
    end
  end
  
  validates_presence_of :common_name, :latin_name, :abbreviation      
  
  # def to_param
  #   "#{id}-#{common_name.downcase.gsub(/[^[:alnum:]]/,'-').gsub(/-{2,}/,'-')}"
  # end
  
  # Returns true if this species has been seen at least thirty times, false otherwise
  def common?
    self.sightings.size > 30
  end
  
  def Species.sort_taxonomic(species_list)
    species_list.sort_by { |s| s ? s.family.taxonomic_sort_id * 100000000000 + s.id : 0 }
  end
  
  def recent_nearby_ebird_sightings(in_location, in_dist = 5)
    EBird.get_JSON('data/obs/geo_spp/recent', {'lng' => in_location.longitude, 'lat' => in_location.latitude, 'sci' => URI.escape(self.latin_name.downcase()), 'dist' => in_dist, 'back' => 5 })
  end   

  def Species.find_all_not_photographed
    Species.find_by_sql(
    "SELECT DISTINCT(species.id), species.* from species, sightings, families 
       WHERE species.id=sightings.species_id AND species.family_id=families.id AND species.aba_countable=1
       AND NOT EXISTS (select species_id from photos WHERE species.id=photos.species_id)
       ORDER BY families.taxonomic_sort_id, species.id")
  end  
  
  # Returns a dictionary where keys are family objects and values are lists of species
  def Species.map_by_family(species_list)
    species_list.inject({}) { | map, species |
       map[species.family] ? map[species.family] << species : map[species.family] = [species] ; map }
  end
  
  # Sort species, first by taxonomic_sort_id and then by species.id field
  def Species.sort_taxonomic(species_list)
    species_list.sort_by { |s| s.family.taxonomic_sort_id * 100000000000 + s.id }
  end
  
  # Find a species for which there was at least one photo from the current week-of-the-year
  def Species.bird_of_the_week
    Species.find_by_sql("SELECT DISTINCT species.* FROM species, photos, trips
      WHERE photos.species_id=species.id AND photos.trip_id=trips.id
      AND WeekOfYear(trips.date)='" + Date.today.cweek.to_s + "'
      ORDER BY trips.date DESC LIMIT 1")[0]
  end

  # Returns the list of species that have been seen in the given year up to the current week-of-the-year
  def Species.year_to_date(year)  
    Species.find_by_sql(
      "SELECT DISTINCT species.* FROM species, families, sightings, trips
         WHERE sightings.species_id=species.id AND species.family_id=families.id AND sightings.trip_id=trips.id AND Year(trips.date)='" + year.to_s + "' 
         AND DayOfYear(trips.date)<='" + Date.today.yday.to_s + "' ORDER BY families.taxonomic_sort_id, species.id")
  end
end
