class BirdWalkerController < ApplicationController
  layout "standard"
  
  def index
    @recent_trips = Trip.find(:all, :limit => 20, :order => 'ignored DESC')
    @page_title = 'Index'
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
