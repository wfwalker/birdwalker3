class StatesController < ApplicationController
  helper :trips
  helper :species
  helper :locations

  def page_kind
    "location"
  end
  
  def show
    @state = State.find(params["id"])
    
    @state.previous && @previous_url = state_url(@state.previous.id)
    @state.next && @next_url = state_url(@state.next.id)
  end

  def show_species_by_year
    @state = State.find(params["id"])
    
    @map, @totals = Sighting.map_by_year_and_species(@state.sightings)
    
    @state.previous && @previous_url = state_url(@state.previous.id)
    @state.next && @next_url = state_url(@state.next.id)
  end

  def show_species_by_month
    @state = State.find(params["id"])
    
    @map, @totals = Sighting.map_by_month_and_species(@state.sightings)
    
    @state.previous && @previous_url = state_url(@state.previous.id)
    @state.next && @next_url = state_url(@state.next.id)
  end
  
  def index
    list
    render :action => 'list'
  end
  
  def list
    @states = State.find(:all)
  end
end
