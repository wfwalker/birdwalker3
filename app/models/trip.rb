class Trip < ActiveRecord::Base
  attr_accessible :name, :date, :leader, :notes, :reference_url

  has_many :sightings do
      def map_by_location
        Sighting.map_by_location(proxy_association.owner.sightings)
      end  
  end
  
  has_many :photos
  
  has_many :species, :through => :sightings, :uniq => true do
    def map_by_family
      load_target
      Species.map_by_family(proxy_association.target)
    end  
  end
  
  has_many :locations, :through => :sightings, :uniq => true, :order => "locations.county_id, locations.name" do
    def with_lat_long
      load_target
      Location.with_lat_long(proxy_association.target)
    end
  end
    
  validates_presence_of :name, :date, :leader
  
  # def to_param
  #   "#{id}-#{name.downcase.gsub(/[^[:alnum:]]/,'-').gsub(/-{2,}/,'-')}"
  # end
  
  def Trip.biggest(tripCount)
    Trip.find_by_sql(["SELECT trips.*, count(distinct(species.id)) AS thecount FROM trips, sightings, species WHERE trips.id=sightings.trip_id AND species.id=sightings.species_id GROUP BY trips.id ORDER BY thecount DESC LIMIT ?", tripCount])
  end

  def Trip.map_by_year(tripList)
    tripList.inject({}) { | map, trip |
       map[trip.date.year] ? map[trip.date.year] << trip : map[trip.date.year] = [trip] ; map }
  end
  
  def Trip.map_by_month(trip_list)
    totals = (1..12).to_a
    for month in (1..12) do
      totals[month] = 0
    end
	
    for trip in trip_list do
      totals[trip.date.month] = totals[trip.date.month] + 1
    end

    return totals
  end

  def Trip.latest(trip_list)
    trip_list.sort{|x,y| y.date <=> x.date}.first
  end

  def Trip.earliest(trip_list)
    trip_list.sort{|x,y| x.date <=> y.date}.first
  end                                             
  
end
