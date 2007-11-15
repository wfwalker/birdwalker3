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
