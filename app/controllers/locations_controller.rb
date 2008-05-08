class LocationsController < ApplicationController
  helper :trips
  helper :species
  helper :sightings
  
  def page_kind
    "locations"
  end
  
  def index
    list
    render :action => 'list'
  end
  
  # for 'http://localhost:3000/', use google maps key
  # ABQIAAAAHB2OV0S5_ezvt-IsSEgTohTJQa0g3IQ9GZqIMmInSLzwtGDKaBTuJCPwK_4hvDn89zQyn5LZWMzcSw

# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  def list
    @locations = Location.find_by_sql("SELECT DISTINCT locations.* from locations, counties, states where locations.county_id=counties.id AND counties.state_id = states.id ORDER BY states.name, locations.name")
  end

  def google
    @location = Location.find(params[:id])
    logger.error("LOCATION GOOGLE " + @location.latitude.to_s + " "  + @location.longitude.to_s)
  end
  
  def show
    @location = Location.find(params[:id])
    
    @location.previous && @previous_url = location_url(@location.previous)
    @location.next && @next_url = location_url(@location.next)
  end

  def show_species_by_year
    @location = Location.find(params[:id])
    
    @map, @totals = Sighting.map_by_year_and_species(@location.sightings)
    
    @location.previous && @previous_url = location_url(@location.previous)
    @location.next && @next_url = location_url(@location.next)
  end

  def show_species_by_month
    @location = Location.find(params[:id])
    
    @map, @totals = Sighting.map_by_month_and_species(@location.sightings)
    
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
      redirect_to location_url(@location)
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
