class LocationsController < ApplicationController
  helper :trips
  helper :species
  helper :sightings
  helper :photos
  
  def page_kind
    "locations"
  end

  def list
    @locations = Location.find_by_county_and_state
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

  def google
    @location = Location.find(params[:id])
  end
  
  def show
    @location = Location.find(params[:id])
  end          
  
  def gallery
    show       
    
    if params[:featured_photo_id] != nil then
      @featured_photo = Photo.find(params[:featured_photo_id])
    else
      @featured_photo = @location.gallery_photos[0]
    end
    
    if params[:start_index] != nil then
      @start_index = params[:start_index].to_i
    else
      @start_index = 0
    end

    @end_index = @start_index + 5
    
    render :action => 'gallery', :layout => 'gallery'
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
    if (! is_editing_allowed?) then
      flash[:notice] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    else
      @location = Location.new
    end
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
                                            
    if (! is_editing_allowed?) then
      flash[:notice] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    end
  end

  def update
    @location = Location.find(params[:id])

    if (! is_editing_allowed?) then
      flash[:notice] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    elsif @location.update_attributes(params[:location])
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
