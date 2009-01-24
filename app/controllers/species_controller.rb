class SpeciesController < ApplicationController
  helper :trips
  helper :locations
  helper :sightings
  helper :photos

  def page_kind
    "species"
  end

  def index
    list
    render :action => 'list'
  end

# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  def list
    @all_species_seen = Species.find_all_seen_not_excluded
  end
  
  def life_list
    all_species_seen = Species.find_all_seen_not_excluded
    @life_sightings = all_species_seen.map(&:first_sighting).flatten.uniq    
  end

  def photo_life_list
    @all_species_photographed = Species.find_all_countable_photographed
  end                        
  
  def photo_to_do_list
    @all_species_not_photographed = Species.find_all_not_photographed
  end
  
  def year_list
    @all_species_seen = Species.find_all_seen_in_year(params[:year])
    @page_title = params[:year].to_s
  end      
  
  def show
    @species = Species.find(params[:id])

    if (@species.common?)
        render :action => 'show_common'
    else
      render :action => 'show_rare'
    end
  end

  def show_locations_by_year
    @species = Species.find(params[:id])
    
    @map, @totals = Sighting.map_by_year_and_location(@species.sightings)
  end

  def show_locations_by_month
    @species = Species.find(params[:id])
    
    @map, @totals = Sighting.map_by_month_and_location(@species.sightings)
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

    if (! is_editing_allowed?) then
      redirect_to species_instance_url(@species)
    end
  end

  def update
    @species = Species.find(params[:id])

    if (! is_editing_allowed?) then
      redirect_to species_instance_url(@species)
    elsif @species.update_attributes(params[:species])
      flash[:notice] = 'Species was successfully updated.'
      redirect_to species_instance_url(@species)
    else
      render :action => 'edit'
    end
  end

  def destroy
    Species.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
