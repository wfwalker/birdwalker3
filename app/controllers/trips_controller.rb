class TripsController < ApplicationController
  helper :locations
  helper :sightings

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
  end
  
  def show
    @trip = Trip.find(params["id"])
    
    @trip.previous && @previous_url = trip_url(@trip.previous)
    @trip.next && @next_url = trip_url(@trip.next)
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
  end

  def create
    @trip = Trip.new(params[:trip])
    if @trip.save
      flash[:notice] = 'Trip was successfully created.'
      redirect_to trip_url(@trip)
    else
      render :action => 'new'
    end
  end

  def edit
    @trip = Trip.find(params[:id])
  end

  def update
    # TODO -- update the sightings, too!!
    @trip = Trip.find(params[:id])
    if @trip.update_attributes(params[:trip])
      flash[:notice] = 'Trip was successfully updated.'
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
