class SightingController < ApplicationController
  scaffold :sighting
  layout "standard"
  
  def edit
    @sighting = Sighting.find(@params["id"])
    @locations = Location.find_all
    @species = Species.find_all
    @page_title = @sighting.species.commonname + ", " + @sighting.location.name + ", " + @sighting.date.to_s
  end
  
  def show
    @sighting = Sighting.find(@params["id"])
    @page_title = @sighting.species.commonname + ", " + @sighting.location.name + ", " + @sighting.date.to_s
  end
end
