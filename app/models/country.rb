class Country < ActiveRecord::Base
  attr_accessible :name, :reference_url

  has_many :states

  has_many :sightings, :through => :states do
      def life        
        Sighting.first_per_taxon(self)
      end
  end

  has_many :taxons, :through => :sightings, :uniq => true, :order => 'taxons.sort'  
      
  has_many :trips, :through => :sightings, :uniq => true
  
  has_many :photos, :through => :locations, :uniq => true

  has_many :locations, :through => :states do
    def with_lat_long
      Location.with_lat_long(self)
    end
  end 

end
