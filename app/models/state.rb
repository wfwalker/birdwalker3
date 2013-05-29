class State < ActiveRecord::Base
  has_many :counties

  belongs_to :country

  attr_accessible :name, :country_id, :abbreviation
  
  has_many :locations, :through => :counties do
    def with_lat_long
      Location.with_lat_long(self)
    end
  end

  validates_presence_of :country_id, :abbreviation, :name

  # def to_param
  #   "#{id}-#{name.downcase.gsub(/[^[:alnum:]]/,'-').gsub(/-{2,}/,'-')}"
  # end
  
  has_many :sightings, :through => :locations do
      def life        
        Sighting.first_per_taxon(self)
      end
  end

  has_many :taxons, :through => :sightings, :uniq => true, :order => 'taxons.sort'  

  has_many :trips, :through => :sightings, :uniq => true
  
  has_many :photos, :through => :locations, :uniq => true
  
  def common?
    self.trips.length > 20
  end
  
  def State.sort_alphabetic(state_list)
    state_list.sort_by { |s| s.name }
  end
end
