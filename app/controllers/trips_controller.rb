class TripsController < ApplicationController
  helper :locations
  helper :sightings
  helper :photos
  
  before_filter :verify_credentials, :only => [:new, :create, :edit, :update, :destroy]  
  before_filter :update_activity_timer, :except => [:new, :create, :edit, :update, :destroy]  
  
  def page_kind
    "trips"
  end
  
  def list
    @trips = Trip.find(:all, :order => "date DESC")
  end

  def list_biggest
    @trips = Trip.biggest(20)
  end
  
  def show
    @trip = Trip.find(params["id"])
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

  def add_species
    @trip = Trip.find(params[:id])
  end

  def update
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
