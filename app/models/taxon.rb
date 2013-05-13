class Taxon < ActiveRecord::Base
  attr_accessible :category, :common_name, :family, :latin_name, :order, :range, :sort

  validates_uniqueness_of :latin_name

  has_many :sightings, :class_name => "Sighting", :foreign_key => "taxon_latin_name", :primary_key => "latin_name" do
    def earliest
      Sighting.earliest(self)
    end                      

    def latest
      Sighting.latest(self)
    end
  end

  has_many :photos, :class_name => "Photo", :foreign_key => "taxon_latin_name", :primary_key => "latin_name" do
    # Returns photos of this Taxon taken during the current week-of-the-year
    def this_week
      Photo.this_week(self)
    end  
  end

  has_many :locations, :through => :sightings, :uniq => true, :order => "locations.county_id, locations.name" do
    # Returns the list of locations for which we have latitude and longitude
    def with_lat_long
      Location.with_lat_long(self)
    end
  end

  # trip-related assocations
  has_many :trips, :through => :sightings, :uniq => true, :order => "trips.date DESC" do
    def earliest
      Trip.earliest(self)
    end                      

    def latest
      Trip.latest(self)
    end
  end

  # different taxon lists
  scope :seen, :include => [ :sightings ], :conditions => [ 'sightings.taxon_latin_name = taxons.latin_name' ], :order => 'taxons.sort'           
  scope :not_excluded, :include => [ :sightings ], :conditions => [ 'sightings.taxon_latin_name = taxons.latin_name AND sightings.exclude = false' ], :order => 'taxons.sort'  
  scope :species_seen, :include => [ :sightings ], :conditions => [ 'sightings.taxon_latin_name = taxons.latin_name AND taxons.category = "species"' ], :order => 'taxons.sort'           
  scope :photographed, :include => [ :photos ], :conditions => [ 'photos.taxon_latin_name = taxons.latin_name' ], :order => 'taxons.sort'

  # Find a species for which there was at least one photo from the current week-of-the-year
  def Taxon.bird_of_the_week
    Taxon.find_by_sql("SELECT DISTINCT taxons.* FROM taxons, photos, trips
      WHERE photos.taxon_latin_name=taxons.latin_name AND photos.trip_id=trips.id
      AND WeekOfYear(trips.date)='" + Date.today.cweek.to_s + "'
      ORDER BY trips.date DESC LIMIT 1")[0]
  end

  # Returns the list of taxons that have been seen in the given year up to the current week-of-the-year
  def Taxon.year_to_date(year)  
    Species.find_by_sql(
      "SELECT DISTINCT taxons.* FROM taxons, sightings, trips
         WHERE sightings.taxon_latin_name=taxons.latin_name AND sightings.trip_id=trips.id AND Year(trips.date)='" + year.to_s + "' 
         AND DayOfYear(trips.date)<='" + Date.today.yday.to_s + "' ORDER BY taxons.sort")
  end

  # Returns true if this species has been seen at least thirty times, false otherwise
  def common?
    self.sightings.size > 30
  end

  # Returns a dictionary where keys are family objects and values are lists of species
  def Taxon.map_by_family(taxon_list)
    taxon_list.inject({}) { | map, taxon |
       map[taxon.family] ? map[taxon.family] << taxon : map[taxon.family] = [taxon] ; map }
  end

  def Taxon.sort_taxonomic(taxon_list)
    taxon_list.sort_by { |s| s.sort }
  end
end
