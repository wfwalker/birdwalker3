class Sighting < ActiveRecord::Base
  belongs_to :location
  belongs_to :trip  
  has_one :taxon, :class_name => "Taxon", :foreign_key => "latin_name", :primary_key => "taxon_latin_name"

  attr_accessible :location_id, :trip_id, :exclude, :heard_only, :count, :notes, :taxon_latin_name
  
  validates_presence_of :location_id, :trip_id, :taxon_latin_name

  validates_numericality_of :count, :allow_nil => true

  validates_uniqueness_of :taxon_latin_name, :scope => [:location_id, :trip_id]

  def full_name
    self.taxon.common_name
  end
  
  def Sighting.year_range
    (1996..2013)
  end   

  def Sighting.seen_during(year)
    Sighting.find_by_sql(["SELECT * FROM sightings, trips WHERE sightings.trip_id = trips.id AND year(trips.date) = ?", year])
  end
  
  def to_ebird_record_format
    # column definitions
    row = []
    # A: Common Name
    row[0]  = self.taxon.common_name
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
    row[6]  = ''
    # H: Longitude
    row[7]  = ''
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
  
  def Sighting.first_per_taxon(sighting_list)         
    # create triples of trip.date, taxon_latin_name, and sighting object
    triples = sighting_list.collect{ |sighting| [sighting.trip.date, sighting.taxon_latin_name, sighting] }.sort{ |x,y| x[0] <=> y[0] }  
    
    # get a list of unique taxon latin_names
    taxon_latin_names = sighting_list.collect{ |sighting| sighting.taxon_latin_name }.uniq

    # use rassoc to find the first triple for each taxon latin_names
    firsts = taxon_latin_names.collect { |taxon_latin_name| triples.rassoc(taxon_latin_name) }

    # return the third item from the first triple for each taxon latin_names
    return firsts.collect { |triple| triple[2] }
  end
    
  def Sighting.map_by_location(sighting_list)
    sighting_list.inject({}) { | map, sighting |
       map[sighting.location] ? map[sighting.location] << sighting : map[sighting.location] = [sighting] ; map }
  end
  
  def Sighting.sort_taxonomic(sighting_list)
    sighting_list.sort_by { |s| s.taxon ? s.taxon.sort : 0 }
  end

  def Sighting.sort_chronological(sighting_list)
    sighting_list.sort { |a, b| a.trip.date == b.trip.date ? a.location_id == b.location_id ? a.taxon.sort <=> b.taxon.sort : a.location_id <=> b.location_id : a.trip.date <=> b.trip.date }.reverse
  end
  
  def Sighting.sort_alphabetic(sighting_list)
    sighting_list.sort_by { |s| s.taxon.common_name }
  end
  
  def Sighting.map_by_family(sighting_list)
    sighting_list.inject({}) { | map, sighting |
       map[sighting.taxon.family] ? map[sighting.taxon.family] << sighting : map[sighting.taxon.family] = [sighting] ; map }
  end

  def Sighting.map_by_family_and_taxon(sighting_list)
    map = {}
    
    for sighting in sighting_list do
      if ! map[sighting.taxon.family] then
        map[sighting.taxon.family] = {}
      end
      
      if ! map[sighting.taxon.family][sighting.taxon] then
        map[sighting.taxon.family][sighting.taxon] = []
      end
      
      map[sighting.taxon.family][sighting.taxon] << sighting      
    end

    return map
  end
  
  def Sighting.map_by_year_and_taxon(sighting_list)
    map = {}
    totals = []
    for year in year_range do
      totals[year] = 0
    end
	
    for sighting in sighting_list do
        if (sighting.taxon) then
          if (!map[sighting.taxon]) then
            map[sighting.taxon] = year_range.to_a
            for year in Sighting.year_range do
              map[sighting.taxon][year] = ''
            end            
          end
        
          if (map[sighting.taxon][sighting.trip.date.year] != 'X') then
            map[sighting.taxon][sighting.trip.date.year] = 'X'
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

  def Sighting.map_by_month_and_taxon(sighting_list)
    map = {}
    totals = []
    for month in (1..12) do
      totals[month] = 0
    end
	
    for sighting in sighting_list do
        if (sighting.taxon) then
          if (!map[sighting.taxon]) then
            map[sighting.taxon] = (1..12).to_a
            for month in (1..12) do
              map[sighting.taxon][month] = ''
            end
          end
        
          if (map[sighting.taxon][sighting.trip.date.month] != 'X') then
            map[sighting.taxon][sighting.trip.date.month] = 'X'
            totals[sighting.trip.date.month] = totals[sighting.trip.date.month] + 1
          end
        end
    end

    return map, totals
  end
end
