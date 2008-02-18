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
    
    @map, @totals = Sighting.map_by_year_and_species(@county.sightings)
    
    @county.previous && @previous_url = county_url(@county.previous)
    @county.next && @next_url = county_url(@county.next)
  end
  
  def page_kind
    "location"
  end
  
  def index
    list
    render :action => 'list'
  end
  
  def list
    @counties = County.find(:all, :order => 'state_id, name')
  end
end
