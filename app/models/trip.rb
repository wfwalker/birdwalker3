class Trip < ActiveRecord::Base
  has_many :sightings do
      def map_by_location
        Sighting.map_by_location(proxy_owner.sightings)
      end  
  end
  has_many :sightings_with_photos, :class_name => 'Sighting', :conditions => 'photo = 1'

  has_many :species, :through => :sightings, :select => "DISTINCT species.*" do
    def map_by_family
      Species.map_by_family(proxy_target)
    end  
  end
  
  has_many :locations, :through => :sightings, :select => "DISTINCT locations.*", :order => "locations.county_id, locations.name" do
    def with_lat_long
      Location.find_by_sql("SELECT locations.* from locations, sightings WHERE sightings.location_id=locations.id AND trip_id=(" + proxy_owner.id.to_s + ") AND latitude != 0 AND longitude != 0")
    end
  end
    
  validates_presence_of :name, :date, :leader
  
  def next
    Trip.find(:first, :conditions => ["date > (?)", self.date.to_s], :order => 'date')
  end

  def previous
    Trip.find(:first, :conditions => ["date < (?)", self.date.to_s], :order => 'date DESC')
  end
  
  def Trip.map_by_year(tripList)
    tripList.inject({}) { | map, trip |
       map[trip.date.year] ? map[trip.date.year] << trip : map[trip.date.year] = [trip] ; map }
  end
end
