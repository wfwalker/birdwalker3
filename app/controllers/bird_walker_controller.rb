class BirdWalkerController < ApplicationController
  helper :trips
  layout "standard"
  
  def index
    @recent_trips = Trip.find(:all, :limit => 20, :order => 'date DESC')
  end
  
  def isLocation
    false
  end
  
  def isTrip
    false
  end
  
  def isSpecies
    false
  end
end
