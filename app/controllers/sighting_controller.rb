class SightingController < ApplicationController
  layout "standard"

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
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @sighting_pages, @sightings = paginate :sightings, :per_page => 10
  end

  def show
    @sighting = Sighting.find(params[:id])
    @page_title = @sighting.species.commonname
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
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @sighting = Sighting.find(params[:id])
    @locations = Location.find_all
    @species = Species.find_all
    @page_title = @sighting.species.commonname
  end

  def update
    @sighting = Sighting.find(params[:id])
    if @sighting.update_attributes(params[:sighting])
      flash[:notice] = 'Sighting was successfully updated.'
      redirect_to :action => 'show', :id => @sighting
    else
      render :action => 'edit'
    end
  end

  def destroy
    Sighting.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
