class CountyController < ApplicationController
  layout "standard"

  def show
    @county = County.new(params["id"])
    @page_title = @county.name + " County"
  end
  
  def isLocation
    true
  end
  
  def isTrip
    false
  end
  
  def isSpecies
    false
  end
end
