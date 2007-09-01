class CountiesController < ApplicationController
  layout "standard"
  
  def show
    @countyname = params["id"]
    @page_title = @countyname + " County"
    @locations = Location.find(:all, :conditions => ["County = ?", params["id"]])
  end
end
