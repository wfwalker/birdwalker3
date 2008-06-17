class CountiesController < ApplicationController
  helper :trips
  helper :species
  helper :locations
  helper :sightings

  def next_and_previous(in_county)
    in_county.previous && @previous_url = county_url(in_county.previous)
    in_county.next && @next_url = county_url(in_county.next)    
  end
  
  def show
    @county = County.find(params["id"])
    next_and_previous(@county)
  end

  def show_species_by_year
    @county = County.find(params["id"])
    @map, @totals = Sighting.map_by_year_and_species(@county.sightings)
    
    next_and_previous(@county)
  end

  def show_species_by_month
    @county = County.find(params["id"])
    @map, @totals = Sighting.map_by_month_and_species(@county.sightings)
    
    next_and_previous(@county)
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
      flash[:notice] = 'Editing not allowed.'
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
      flash[:notice] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    end
  end

  def update
    @county = County.find(params[:id])

    if (! is_editing_allowed?) then
      flash[:notice] = 'Editing not allowed.'
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
end
