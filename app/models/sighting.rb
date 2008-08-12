class Sighting < ActiveRecord::Base
  belongs_to :location
  belongs_to :species
  belongs_to :trip
  
  validates_presence_of :species_id, :location_id, :trip_id
    
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
  
  def Sighting.map_by_year_and_species(sighting_list)
    map = {}
    totals = (1996.2008).to_a
    for year in (1996..2008) do
      totals[year] = 0
    end
	
    for sighting in sighting_list do
        if (sighting.species) then
          if (!map[sighting.species]) then
            map[sighting.species] = (1996..2008).to_a
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
    totals = (1996.2008).to_a
    for year in (1996..2008) do
      totals[year] = 0
    end
	
    for sighting in sighting_list do
        if (sighting.location) then
          if (!map[sighting.location]) then
            map[sighting.location] = (1996..2008).to_a
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
    totals = (1996.2008).to_a
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
    totals = (1..12).to_a
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
