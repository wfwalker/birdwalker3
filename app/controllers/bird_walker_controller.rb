class BirdWalkerController < ApplicationController
  helper :trips
  
  def index
    @recent_trips = Trip.find(:all, :limit => 20, :order => 'date DESC')
  end

  def about
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
