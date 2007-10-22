class SightingsController < ApplicationController
  layout "standard"
  auto_complete_for :species, :common_name
 
# here's the autocomplete voodoo, put this in someplace, some time 
#  <p>
# <%= text_field_with_auto_complete :species, :common_name %>
#  </p>  

  def isLocation
    false
  end
  
  def isTrip
    false
  end
  
  def isSpecies
    false
  end
  
  def index
    list
    render :action => 'list'
  end

# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  def list
    @sighting_pages, @sightings = paginate :sightings, :per_page => 10
  end

  def show
    @sighting = Sighting.find(params[:id])
    @page_title = @sighting.species.common_name
  end

  def new
    @sighting = Sighting.new
    if (params[:trip_id] != "")
      @sighting.trip_id = params[:trip_id]
    end
    @page_title = "New Sighting"
  end

  def create
    @sighting = Sighting.new(params[:sighting])
    if @sighting.save
      flash[:notice] = 'Sighting was successfully created.'
      redirect_to trip_url(@sighting.trip_id)
    else
      render :action => 'new'
    end
  end

  def edit
    logger.error("START edit");
    @sighting = Sighting.find(params[:id])
    @page_title = @sighting.species.common_name
  end

  def update
    @sighting = Sighting.find(params[:id])
    if @sighting.update_attributes(params[:sighting])
      logger.error("did successful update of sighting");
      flash[:notice] = 'Sighting was successfully updated.'
      redirect_to trip_url(@sighting.trip_id)
    else
      logger.error("did NOT successful update of sighting");
      render :action => 'edit'
    end
  end

  def destroy
    Sighting.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def autocomplete_species
      @species_list = Species.find(:all, :conditions => ["common_name like ?", "%#{params[:sighting][:species]}%"])
  end
end
