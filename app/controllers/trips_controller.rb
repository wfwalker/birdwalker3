class TripsController < ApplicationController
  helper :locations
  helper :sightings
  helper :photos
  
  before_filter :verify_credentials, :only => [:new, :create, :edit, :update, :destroy]  
  before_filter :update_activity_timer, :except => [:new, :create, :edit, :update, :destroy]  
  
  caches_action :list, :index, :show, :layout => false
  
  def page_kind
    "trips"
  end
  
  def list
    @page_title = "Trips"
    @trips = Trip.find(:all, :order => "date DESC")
  end

  def list_biggest
    @page_title = "Biggest Trips"
    @trips = Trip.biggest(20)
  end
  
  def show
    @trip = Trip.find(params["id"])
    @page_title = @trip.name
    
    if @trip.sightings.length == 0
      render :action => 'blog_show'
    end
  end
  
  def show_as_ebird_record_format
    @trip = Trip.find(params["id"])
    render :text => @trip.sightings.collect { | a_sighting | a_sighting.to_ebird_record_format.join(",") }
  end
  
  def index
    list
    @page_title = "Trips"
    render :action => 'list'
  end

# WFW -- THIS BREAKS EVERYTHING!!!!
# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
# verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  def new
    @trip = Trip.new
    @page_title = "new"
  end

  def create
    @trip = Trip.new(params[:trip])
    @page_title = "new"
    
    if @trip.save
      flash[:notice] = 'Trip was successfully created.'
      expire_action :action => [:index, :list, :show]
      redirect_to trip_url(@trip)
    else
      render :action => 'new'
    end
  end

  def edit
    @trip = Trip.find(params[:id])
    @page_title = @trip.name
  end

  def add_species
    @trip = Trip.find(params[:id])
    expire_action :action => :show
    @page_title = @trip.name
  end

  def update
    @trip = Trip.find(params[:id])
    @page_title = @trip.name

    if @trip.update_attributes(params[:trip])
      flash[:notice] = 'Trip was successfully updated.'
      expire_action :action => [:index, :list, :show]
      redirect_to trip_url(@trip)
    else
      render :action => 'edit'
    end
  end

  def destroy
    Trip.find(params[:id]).destroy
    expire_action :action => [:index, :list]
    redirect_to :action => 'list'
  end
end
