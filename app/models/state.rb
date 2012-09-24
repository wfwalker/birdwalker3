class State < ActiveRecord::Base
  has_many :counties
  
  has_many :locations, :through => :counties do
    def with_lat_long
      Location.with_lat_long(self)
    end
  end

  # def to_param
  #   "#{id}-#{name.downcase.gsub(/[^[:alnum:]]/,'-').gsub(/-{2,}/,'-')}"
  # end
  
  has_many :sightings, :through => :locations do
      def life        
        Sighting.first_per_species(self)
      end
  end

  has_many :species, :through => :sightings, :uniq => true
      
  has_many :trips, :through => :sightings
  
  has_many :photos, :through => :locations
  
  def common?
    self.trips.length > 20
  end
  
  def State.sort_alphabetic(state_list)
    state_list.sort_by { |s| s.name }
  end
end
