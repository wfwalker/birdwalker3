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
  
  has_many :species, :class_name => 'Species', :finder_sql => 'SELECT DISTINCT species.* FROM species, families, sightings, locations, counties 
      WHERE species.id=sightings.species_id AND species.family_id=families.id AND sightings.location_id=locations.id AND
      locations.county_id=counties.id AND counties.state_id=#{id} ORDER BY families.taxonomic_sort_id, species.id'
      
  has_many :sightings, :class_name => 'Sighting', :finder_sql => 'SELECT DISTINCT sightings.* FROM sightings, locations, counties 
      WHERE sightings.location_id=locations.id AND locations.county_id=counties.id AND counties.state_id=#{id} ORDER BY sightings.id' do

      def life        
        Sighting.first_per_species(self)
      end

  end
  
  has_many :trips, :class_name => 'Trip', :finder_sql => 'SELECT DISTINCT trips.* FROM trips, sightings, locations, counties 
      WHERE trips.id=sightings.trip_id AND sightings.location_id=locations.id AND
      locations.county_id=counties.id AND counties.state_id=#{id}'
  
  has_many :photos, :class_name => 'Photo', :finder_sql => 'SELECT DISTINCT photos.* FROM photos, locations, counties 
      WHERE photos.location_id=locations.id AND
      locations.county_id=counties.id AND counties.state_id=#{id} ORDER BY photos.id DESC LIMIT #{Photo.default_gallery_size()}'
  
  def common?
    self.trips.length > 20
  end
  
  def State.sort_alphabetic(state_list)
    state_list.sort_by { |s| s.name }
  end
end
