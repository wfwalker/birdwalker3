class Trip < ActiveRecord::Base
  has_many :sightings, :order => "species_id" do
      def map_by_location
        Sighting.map_by_location(proxy_owner.sightings)
      end  
  end

  has_many :species, :through => :sightings, :select => "DISTINCT species.*", :order => "species.id" do
    def map_by_family
      Species.map_by_family(proxy_target)
    end  
  end
  
  has_many :locations, :through => :sightings, :select => "DISTINCT locations.*", :order => "locations.state, locations.county, locations.name"
    
  validates_presence_of :name, :date, :leader
  
  def find_all_photos
    Sighting.find(:all, :conditions => ["trip_id = " + self.id.to_s + " AND photo = 1"], :order => "species_id")
  end
  
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
