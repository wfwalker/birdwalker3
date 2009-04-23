class TripsController < ApplicationController
  helper :locations
  helper :sightings
  helper :photos
  
  def page_kind
    "trips"
  end
  
  def list
    @trips = Trip.find(:all, :order => "date DESC")
  end

  def list_biggest
    @trips = Trip.biggest(15)
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
    if (! is_editing_allowed?) then
      flash[:error] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    else
      @trip = Trip.new
    end
  end

  def create
    @trip = Trip.new(params[:trip])
    
    if (! is_editing_allowed?) then
      flash[:error] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    elsif @trip.save
      flash[:notice] = 'Trip was successfully created.'
      redirect_to trip_url(@trip)
    else
      render :action => 'new'
    end
  end

  def edit
    @trip = Trip.find(params[:id])

    if (! is_editing_allowed?) then
      flash[:error] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    end
  end

  def add_species
    @trip = Trip.find(params[:id])

    if (! is_editing_allowed?) then
      flash[:error] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    end
  end

  def edit_sightings
    @trip = Trip.find(params[:id])

    if (! is_editing_allowed?) then
      flash[:error] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    end
  end

  def update
    @trip = Trip.find(params[:id])

    if (! is_editing_allowed?) then
      flash[:error] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    elsif @trip.update_attributes(params[:trip])
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
