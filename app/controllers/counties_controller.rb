class CountiesController < ApplicationController
  helper :trips
  helper :species
  helper :locations
  helper :sightings
  helper :photos
  
  def show
    @county = County.find(params["id"])

    if @county.common?
        render :action => 'show_common'
      else
        render :action => 'show_rare'
    end
  end

  def gallery
    @county = County.find(params["id"])
    
    if params[:featured_photo_id] != nil then
      @featured_photo = Photo.find(params[:featured_photo_id])
    else
      @featured_photo = @county.gallery_photos[0]
    end
    
    if params[:start_index] != nil then
      @start_index = params[:start_index].to_i
    else
      @start_index = 0
    end

    @end_index = @start_index + gallery_page_size() - 1
    
    render :action => 'gallery'
  end

  def show_species_by_year
    @county = County.find(params["id"])
    @map, @totals = Sighting.map_by_year_and_species(@county.sightings)
  end

  def show_species_by_month
    @county = County.find(params["id"])
    @map, @totals = Sighting.map_by_month_and_species(@county.sightings)
  end
  
  def page_kind
    "counties"
  end              

  def new
    @county = County.new
  end

  def create
    @county = County.new(params[:county])

    if (! is_editing_allowed?) then
      flash[:error] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    elsif @county.save
      flash[:notice] = 'County was successfully created.'
      redirect_to county_url(@county)
    else
      render :action => 'new'
    end
  end        
  
  def edit
    @county = County.find(params[:id])

    if (! is_editing_allowed?) then
      flash[:error] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    end
  end

  def update
    @county = County.find(params[:id])

    if (! is_editing_allowed?) then
      flash[:error] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    elsif @county.update_attributes(params[:location])
      flash[:notice] = 'County was successfully updated.'
      redirect_to county_url(@county)
    else
      render :action => 'edit'
    end
  end    

  def destroy
    County.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
    
  def index
    list
    render :action => 'list'
  end
  
  def list
    @counties = County.find(:all, :order => 'state_id, name')
  end
  
  def gallery_page_size()
	  10
  end
end
