class StatesController < ApplicationController
  helper :trips
  helper :species
  helper :locations
  helper :photos

  before_filter :update_activity_timer  
  
  caches_action :list, :index, :show, :layout => false

  def page_kind
    "states"
  end
  
  def show
    @state = State.find(params["id"])
    @page_title = @state.name
  end

  def show_species_by_year
    @state = State.find(params["id"])
    @page_title = @state.name
    
    @map, @totals = Sighting.map_by_year_and_species(@state.sightings)
  end

  def show_species_by_month
    @state = State.find(params["id"])
    @page_title = @state.name
    
    @map, @totals = Sighting.map_by_month_and_species(@state.sightings)
  end
  
  def index
    list
    @page_title = "States"
    render :action => 'list'
  end
  
  def list
    @page_title = "States"
    @states = State.find(:all)
  end
end
