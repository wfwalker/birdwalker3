class SpeciesController < ApplicationController
  helper :trips
  helper :locations
  helper :sightings
  helper :photos
  
  before_filter :verify_credentials, :only => [:new, :create, :edit, :update, :destroy]  
  before_filter :update_activity_timer, :except => [:new, :create, :edit, :update, :destroy]  
  
  caches_action :list, :life_list, :index, :show, :layout => false

  def page_kind
    "species"
  end

  def index
    list
    @page_title = "Species"
    render :action => 'list'
  end

# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  def list
    @page_title = "Birding Life List"
    @all_species_seen = Species.seen_not_excluded.countable
  end
  
  def life_list
    @page_title = "Birding Life List"
    all_species_seen = Species.seen_not_excluded.countable
    @life_sightings = all_species_seen.collect {|x| x.sightings.earliest}
  end

  def photo_life_list
    @page_title = "Photo Life List"
    @all_species_photographed = Species.photographed.countable
  end                        

  def year_list
    @all_species_seen = Species.seen_during(params[:year])
    @page_title = params[:year].to_s   
    
    render :action => 'list'
  end      
  
  def show
    @species = Species.find(params[:id])
    @page_title = @species.common_name
  end

  def recent_nearby_ebird_sightings(location)
    @species = Species.find(params[:id])
    
    if params[:dist] then
      render :json => @species.recent_nearby_ebird_sightings(location, params[:dist])
    else
      render :json => @species.recent_nearby_ebird_sightings(location)
    end
  end      

  def show_locations_by_year
    @species = Species.find(params[:id])
    @page_title = @species.common_name
    
    @map, @totals = Sighting.map_by_year_and_location(@species.sightings)
  end

  def show_locations_by_month
    @species = Species.find(params[:id])
    @page_title = @species.common_name
    
    @map, @totals = Sighting.map_by_month_and_location(@species.sightings)
  end

  def new
    @species = Species.new
    @page_title = "new"   
  end

  def create
    @species = Species.new(params[:species])
    @page_title = "new"   

    if @species.save
      flash[:notice] = 'Species was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit    
    @species = Species.find(params[:id])
    @page_title = "new"   
  end

  def update
    @species = Species.find(params[:id])
    @page_title = @species.common_name

    if @species.update_attributes(params[:species])
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
