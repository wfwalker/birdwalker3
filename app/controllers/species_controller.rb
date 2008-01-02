class SpeciesController < ApplicationController
  helper :trips
  helper :locations
  helper :sightings

  def isLocation
    false
  end
  
  def isTrip
    false
  end
  
  def isSpecies
    true
  end

  def index
    list
    render :action => 'list'
  end

# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  def list
    @all_species_seen = Species.find_all_seen
  end
  
  def life_list
    all_species_seen = Species.find_all_seen_not_excluded
    @life_sightings = all_species_seen.map(&:first_sighting).flatten.uniq    
    render :action => 'life_list'
  end

  def show
    @species = Species.find(params[:id])
    
    @species.previous && @previous_url = species_instance_url(@species.previous)
    @species.next && @next_url = species_instance_url(@species.next)
  end

  def new
    @species = Species.new
  end

  def create
    @species = Species.new(params[:species])
    if @species.save
      flash[:notice] = 'Species was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @species = Species.find(params[:id])
  end

  def update
    @species = Species.find(params[:id])
    if @species.update_attributes(params[:species])
      flash[:notice] = 'Species was successfully updated.'
      redirect_to species_url(@species)
    else
      render :action => 'edit'
    end
  end

  def destroy
    Species.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
