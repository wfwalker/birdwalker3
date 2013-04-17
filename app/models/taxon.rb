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

  has_many :photos, :class_name => "Photo", :foreign_key => "taxon_latin_name", :primary_key => "latin_name"

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

  scope :species_seen, :include => [ :sightings ], :conditions => [ 'sightings.taxon_latin_name = taxons.latin_name AND taxons.category = "species"' ], :order => 'taxons.sort'           

  # Returns true if this species has been seen at least thirty times, false otherwise
  def common?
    self.sightings.size > 30
  end

  # Returns a dictionary where keys are family objects and values are lists of species
  def Taxon.map_by_family(taxon_list)
    taxon_list.inject({}) { | map, taxon |
       map[taxon.family] ? map[taxon.family] << taxon : map[taxon.family] = [taxon] ; map }
  end

end
