class SpeciesController < ApplicationController
  scaffold :species
  layout "standard"
  
  def list
    @species = Species.find_all_seen
    @page_title = "Species"
  end
  
  def show
    @species = Species.find(params["id"])
    @page_title = @species.commonname
  end
end
