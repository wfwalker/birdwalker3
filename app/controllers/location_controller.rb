class LocationController < ApplicationController
  scaffold :location
  layout "standard"
  
  def show
    @location = Location.find(params["id"])
    @page_title = @location.name
  end
  
  def list
    @locations = Location.find_all
    @page_title = "Locations"
  end
end
