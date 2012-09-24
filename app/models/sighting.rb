class Sighting < ActiveRecord::Base
  belongs_to :location
  belongs_to :species
  belongs_to :trip  

  attr_accessible :species_id, :location_id, :trip_id
  
  validates_presence_of :species_id, :location_id, :trip_id        

  validates_numericality_of :count, :allow_nil => true

  validates_uniqueness_of :species_id, :scope => [:location_id, :trip_id]

  def full_name
    self.species.common_name
  end
  
  def Sighting.year_range
    (1996..2012)
  end   

  def Sighting.seen_during(year)
    Sighting.find_by_sql(["SELECT * FROM sightings, trips WHERE sightings.trip_id = trips.id AND year(trips.date) = ?", year])
  end
  
  def to_ebird_record_format
    # column definitions
    row = []
    # A: Common Name
    row[0]  = self.species.common_name
    # B: Genus (Latin)
    row[1]  = ''
    # C: Species (Latin)
    row[2]  =  ''
    # D: Number
    row[3]  = (self.count ? self.count.to_s : "X")
    # E: Species Comments
    row[4]  = ''
    # F: Location Name
    row[5]  = self.location.name
    # G: Latitude
    row[6]  = (self.location.latitude ? self.location.latitude.to_s : '')
    # H: Longitude
    row[7]  = (self.location.longitude ? self.location.longitude.to_s : '')
    # I: Date
    row[8]  = self.trip.date.strftime("%m/%d/%Y")
    
    # J: Start Time
    row[9]  = ''
    # K: State/Province
    row[10] = self.location.county.state.abbreviation
    # L: Country Code
    row[11] = (self.location.county.state == "Alberta" ? "CA" : "US")
    # M: Protocol
    row[12] = 'casual'
    # N: Number of Observers
    row[13] = ''
    # O: Duration (mins)
    row[14] = ''
    # P: All observations reported? (Y/N)
    row[15] = 'Y'
    # Q: Distance Covered
    row[16] = ''
    # R: Area Covered
    row[17] = ''
    # S: Checklist comments
    row[18] = ''
    
    return row
  end
  
  def Sighting.latest(sighting_list)
    sighting_list.sort{|x,y| y.trip.date <=> x.trip.date}.first
  end

  def Sighting.earliest(sighting_list)
    sighting_list.sort{|x,y| x.trip.date <=> y.trip.date}.first
  end                                             
  
  def Sighting.first_per_species(sighting_list)         
    # create triples of trip.date, species_id, and sighting object
    triples = sighting_list.collect{ |sighting| [sighting.trip.date, sighting.species_id, sighting] }.sort{ |x,y| x[0] <=> y[0] }  
    
    # get a list of unique species_ids
    species_ids = sighting_list.collect{ |sighting| sighting.species_id }.uniq

    # use rassoc to find the first triple for each species_id
    firsts = species_ids.collect { |species_id| triples.rassoc(species_id) }

    # return the third item from the first triple for each species_id
    return firsts.collect { |triple| triple[2] }
  end
    
  def Sighting.map_by_location(sighting_list)
    sighting_list.inject({}) { | map, sighting |
       map[sighting.location] ? map[sighting.location] << sighting : map[sighting.location] = [sighting] ; map }
  end
  
  def Sighting.sort_taxonomic(sighting_list)
    sighting_list.sort_by { |s| s.species ? s.species.family.taxonomic_sort_id * 100000000000 + s.species_id : 0 }
  end

  def Sighting.sort_chronological(sighting_list)
    sighting_list.sort { |a, b| a.trip.date == b.trip.date ? a.location_id == b.location_id ? a.species_id <=> b.species_id : a.location_id <=> b.location_id : a.trip.date <=> b.trip.date }.reverse
  end
  
  def Sighting.sort_alphabetic(sighting_list)
    sighting_list.sort_by { |s| s.species.common_name }
  end
  
  def Sighting.map_by_family(sighting_list)
    sighting_list.inject({}) { | map, sighting |
       map[sighting.species.family] ? map[sighting.species.family] << sighting : map[sighting.species.family] = [sighting] ; map }
  end

  def Sighting.map_by_family_and_species(sighting_list)
    map = {}
    
    for sighting in sighting_list do
      if ! map[sighting.species.family] then
        map[sighting.species.family] = {}
      end
      
      if ! map[sighting.species.family][sighting.species] then
        map[sighting.species.family][sighting.species] = []
      end
      
      map[sighting.species.family][sighting.species] << sighting      
    end

    return map
  end
  
  def Sighting.map_by_year_and_species(sighting_list)
    map = {}
    totals = []
    for year in year_range do
      totals[year] = 0
    end
	
    for sighting in sighting_list do
        if (sighting.species) then
          if (!map[sighting.species]) then
            map[sighting.species] = year_range.to_a
            for year in Sighting.year_range do
              map[sighting.species][year] = ''
            end            
          end
        
          if (map[sighting.species][sighting.trip.date.year] != 'X') then
            map[sighting.species][sighting.trip.date.year] = 'X'
            totals[sighting.trip.date.year] = totals[sighting.trip.date.year] + 1
          end
        end
    end
    
    return map, totals
  end

  def Sighting.map_by_year_and_location(sighting_list)
    map = {}
    totals = []
    for year in year_range do
      totals[year] = 0
    end
	
    for sighting in sighting_list do
        if (sighting.location) then
          if (!map[sighting.location]) then
            map[sighting.location] = year_range.to_a
          end
        
          if (map[sighting.location][sighting.trip.date.year] != 'X') then
            map[sighting.location][sighting.trip.date.year] = 'X'
            totals[sighting.trip.date.year] = totals[sighting.trip.date.year] + 1
          end
        end
    end

    return map, totals
  end                   

  def Sighting.map_by_month(sighting_list)
    totals = (1..12).to_a
    for month in (1..12) do
      totals[month] = 0
    end
	
    for sighting in sighting_list do
      totals[sighting.trip.date.month] = totals[sighting.trip.date.month] + 1
    end

    return totals
  end

  def Sighting.map_by_month_and_location(sighting_list)
    map = {}
    totals = []
    for month in (1..12) do
      totals[month] = 0
    end
	
    for sighting in sighting_list do
        if (sighting.location) then
          if (!map[sighting.location]) then
            map[sighting.location] = (1..12).to_a
            for month in (1..12) do
              map[sighting.location][month] = ''
            end
          end
        
          if (map[sighting.location][sighting.trip.date.month] != 'X') then
            map[sighting.location][sighting.trip.date.month] = 'X'
            totals[sighting.trip.date.month] = totals[sighting.trip.date.month] + 1
          end
        end
    end

    return map, totals
  end

  def Sighting.map_by_month_and_species(sighting_list)
    map = {}
    totals = []
    for month in (1..12) do
      totals[month] = 0
    end
	
    for sighting in sighting_list do
        if (sighting.species) then
          if (!map[sighting.species]) then
            map[sighting.species] = (1..12).to_a
            for month in (1..12) do
              map[sighting.species][month] = ''
            end
          end
        
          if (map[sighting.species][sighting.trip.date.month] != 'X') then
            map[sighting.species][sighting.trip.date.month] = 'X'
            totals[sighting.trip.date.month] = totals[sighting.trip.date.month] + 1
          end
        end
    end

    return map, totals
  end
end
