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

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @county }
      format.json  { render :json => @county }
    end
  end

  def locations
    @county = County.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @county.locations }
      format.json  { render :json => @county.locations }
    end
  end
  
  def show_chronological_list
    @county = County.find(params["id"])
    @page_title = @county.full_name
    @life_sightings = @county.sightings.life
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
