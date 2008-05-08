class CountiesController < ApplicationController
  helper :trips
  helper :species
  helper :locations
  helper :sightings

  def next_and_previous(in_county)
    in_county.previous && @previous_url = county_url(in_county.previous)
    in_county.next && @next_url = county_url(in_county.next)    
  end
  
  def show
    @county = County.find(params["id"])
    next_and_previous(@county)
  end

  def show_species_by_year
    @county = County.find(params["id"])
    @map, @totals = Sighting.map_by_year_and_species(@county.sightings)
    
    next_and_previous(@county)
  end

  def show_species_by_month
    @county = County.find(params["id"])
    @map, @totals = Sighting.map_by_month_and_species(@county.sightings)
    
    next_and_previous(@county)
  end
  
  def page_kind
    "counties"
  end
  
  def index
    list
    render :action => 'list'
  end
  
  def list
    @counties = County.find(:all, :order => 'state_id, name')
  end
end
