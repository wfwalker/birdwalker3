class CountiesController < ApplicationController
  helper :trips
  helper :species
  helper :locations
  helper :sightings
  helper :photos
  
  before_filter :verify_credentials, :only => [:new, :create, :edit, :update, :destroy]  
  before_filter :update_activity_timer, :except => [:new, :create, :edit, :update, :destroy]  
  
  caches_action :list, :index, :show, :layout => false
  
  def show
    @county = County.find(params["id"])
    @page_title = @county.full_name

    if @county.common?
        render :action => 'show_common'
      else
        render :action => 'show_rare'
    end
  end

  def gallery
    @county = County.find(params["id"])
    @page_title = @county.full_name
    
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
    @page_title = @county.full_name
    @map, @totals = Sighting.map_by_year_and_species(@county.sightings)
  end

  def show_species_by_month
    @county = County.find(params["id"])
    @page_title = @county.full_name
    @map, @totals = Sighting.map_by_month_and_species(@county.sightings)
  end
  
  def page_kind
    "counties"
  end              

  def new
    @county = County.new
    @page_title = "new"
  end

  def create
    @county = County.new(params[:county])
    @page_title = "new"

    if @county.save
      flash[:notice] = 'County was successfully created.'
      redirect_to county_url(@county)
    else
      render :action => 'new'
    end
  end        
  
  def edit
    @county = County.find(params[:id])
    @page_title = @county.full_name
  end

  def update
    @county = County.find(params[:id])
    @page_title = @county.full_name

    if @county.update_attributes(params[:location])
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
    @page_title = "Counties"
    render :action => 'list'
  end
  
  def list
    @page_title = "Counties"
    @counties = County.find(:all, :order => 'state_id, name')
  end
  
  def gallery_page_size()
	  10
  end
end
