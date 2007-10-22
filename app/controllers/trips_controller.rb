class TripsController < ApplicationController
  helper :locations
  layout "standard"

  def isLocation
    false
  end
  
  def isTrip
    true
  end
  
  def isSpecies
    false
  end
  
  def list
    @trips = Trip.find(:all, :order => "date DESC")
    @trips_by_year = Trip.map_by_year(@trips)
    @page_title = "Trips"
  end
  
  def show
    @trip = Trip.find(params["id"])
    @page_title = @trip.name
  end
  
  def index
    list
    render :action => 'list'
  end

# WFW -- THIS BREAKS EVERYTHING!!!!
# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
# verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  def new
    @trip = Trip.new
    @page_title = "New Trip"
  end

  def create
    @trip = Trip.new(params[:trip])
    if @trip.save
      flash[:notice] = 'Trip was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    logger.error("*************** START EDIT TRIP");
    @trip = Trip.find(params[:id])
    @page_title = @trip.name
  end

  def update
    logger.error("*************** START UPDATE TRIP");
    # TODO -- update the sightings, too!!
    @trip = Trip.find(params[:id])
    if @trip.update_attributes(params[:trip])
      flash[:notice] = 'Trip was successfully updated.'
      logger.error("UPDATED TRIP");
      redirect_to trip_url(@trip)
    else
      render :action => 'edit'
    end
  end

  def destroy
    Trip.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
