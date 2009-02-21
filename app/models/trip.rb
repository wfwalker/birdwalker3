class Trip < ActiveRecord::Base
  has_many :sightings do
      def map_by_location
        Sighting.map_by_location(proxy_owner.sightings)
      end  
  end
  
  has_many :photos
  
  has_many :species, :through => :sightings, :uniq => true, :order => "species.taxonomic_sort_id, species.id" do
    def map_by_family
      load_target
      Species.map_by_family(proxy_target)
    end  
  end
  
  has_many :locations, :through => :sightings, :uniq => true, :order => "locations.county_id, locations.name" do
    def with_lat_long
      load_target
      Location.with_lat_long(proxy_target)
    end
  end
    
  validates_presence_of :name, :date, :leader

  def Trip.map_by_year(tripList)
    tripList.inject({}) { | map, trip |
       map[trip.date.year] ? map[trip.date.year] << trip : map[trip.date.year] = [trip] ; map }
  end
end
