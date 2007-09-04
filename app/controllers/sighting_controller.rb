class SightingController < ApplicationController
  scaffold :sighting
  layout "standard"
  
  def isLocation
    false
  end
  
  def isTrip
    false
  end
  
  def isSpecies
    false
  end
  
  def edit
    @sighting = Sighting.find(@params["id"])
    @locations = Location.find_all
    @species = Species.find_all
    @page_title = @sighting.species.commonname
  end
  
  def show
    @sighting = Sighting.find(@params["id"])
    @page_title = @sighting.species.commonname
  end
end
