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
    @recent_trips = Trip.find(:all, :limit => 8, :order => 'date DESC')
  end

  def list_biggest
    @page_title = "Biggest Trips"
    @trips = Trip.biggest(20)
  end
  
  def show
    @trip = Trip.find(params["id"])
    @page_title = @trip.name

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @trip.to_xml(:include => [ :sightings, :photos ]) }
      format.json  { render :json => @trip.to_json(:include => [ :sightings, :photos ]) }
    end
  end

  def locations
    @trip = Trip.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @trip.locations }
      format.json  { render :json => @trip.locations }
    end
  end
  
  def show_as_ebird_record_format
    @trip = Trip.find(params["id"])
    sighting_exports = @trip.sightings.collect { | a_sighting | a_sighting.to_ebird_record_format.join(",") }
    render :text => sighting_exports.join("\n"), :content_type => 'text/plain'
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
