class CountiesController < ApplicationController
  helper :trips
  helper :species
  helper :locations
  helper :sightings

  def show
    @county = County.find(params["id"])
    
    @county.previous && @previous_url = county_url(@county.previous)
    @county.next && @next_url = county_url(@county.next)
  end

  def show_species_by_year
    @county = County.find(params["id"])
    
    @map = {}
    @totals = (1996.2008).to_a
    for year in (1996..2008) do
      @totals[year] = 0
    end
		
    
    for sighting in @county.sightings do
        if (sighting.species) then
          if (!@map[sighting.species]) then
            @map[sighting.species] = (1996..2008).to_a
          end
          
          if (@map[sighting.species][sighting.trip.date.year] != '1') then
            @map[sighting.species][sighting.trip.date.year] = 'X'
            @totals[sighting.trip.date.year] = @totals[sighting.trip.date.year] + 1
          end
        end
    end
    
    @county.previous && @previous_url = county_url(@county.previous)
    @county.next && @next_url = county_url(@county.next)
  end
  
  def isLocation
    true
  end
  
  def isTrip
    false
  end
  
  def isSpecies
    false
  end
  
  def index
    list
    render :action => 'list'
  end
  
  def list
    @counties = County.find(:all, :order => 'state_id, name')
  end
end
