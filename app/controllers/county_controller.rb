class CountyController < ApplicationController
  layout "standard"

  def show
    @county = County.new(params["id"])
    puts"MOOOO"
    @page_title = @county.name + " County"
  end
end
