class StatesController < ApplicationController
  scaffold :state
  layout "standard"
  
  def isLocation
    true
  end
  
  def isTrip
    false
  end
  
  def isSpecies
    false
  end
  
  def show
    @state = State.find(params["id"])
    @page_title = @state.name
  end
  
  def list
    @states = State.find_all
    @page_title = "States"
  end
end
