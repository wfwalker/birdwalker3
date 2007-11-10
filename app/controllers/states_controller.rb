class StatesController < ApplicationController
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
