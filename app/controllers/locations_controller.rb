class LocationsController < ApplicationController
  helper :trips
  helper :species
  
  def isLocation
    true
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
    @locations = Location.find(:all, :order => "name")
    @locations_by_state = Location.map_by_state(@locations)
  end

  def show
    @location = Location.find(params[:id])
    
    @location.previous && @previous_url = location_url(@location.previous)
    @location.next && @next_url = location_url(@location.next)
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(params[:location])
    if @location.save
      flash[:notice] = 'Location was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(params[:location])
      flash[:notice] = 'Location was successfully updated.'
      redirect_to location_url(@location)
    else
      render :action => 'edit'
    end
  end

  def destroy
    Location.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
