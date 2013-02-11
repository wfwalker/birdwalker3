class FamiliesController < ApplicationController
  helper :species
  helper :trips
  helper :locations
  helper :sightings
  helper :photos

  before_filter :verify_credentials, :only => [:new, :create, :edit, :update, :destroy]  
  before_filter :update_activity_timer, :except => [:new, :create, :edit, :update, :destroy]  
  
  # caches_action :list, :index, :show, :layout => false
  
  def page_kind
    "species"
  end

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  #verify :method => :post, :only => [ :destroy, :create, :update ],
  #       :redirect_to => { :action => :list }

  def list
    @page_title = 'Families'
    @families = Family.find_all_seen
    @notable_families = @families.select { |family| family.species_seen.size > 5} 
    @misc_families = @families.select { |family| family.species_seen.size <= 5} 
  end

  def show
    @family = Family.find(params[:id])
    @page_title = @family.common_name

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @family }
      format.json  { render :json => @family }
    end
  end

  def locations
    @family = Family.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @family.locations }
      format.json  { render :json => @family.locations }
    end
  end

  def show_species_by_year
    @family = Family.find(params[:id])
    @page_title = @family.common_name
    
    @map, @totals = Sighting.map_by_year_and_species(@family.sightings)
  end

  def show_species_by_month
    @family = Family.find(params[:id])
    @page_title = @family.common_name
    
    @map, @totals = Sighting.map_by_month_and_species(@family.sightings)
  end

  def new
    @family = Family.new
    @page_title = "new"
  end

  def create
    @family = Family.new(params[:family])
    @page_title = "new"

    if @family.save
      flash[:notice] = 'Family was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @family = Family.find(params[:id])
    @page_title = @family.common_name
  end

  def update
    @family = Family.find(params[:id])
    @page_title = @family.common_name

    if @family.update_attributes(params[:family])
      flash[:notice] = 'Family was successfully updated.'
      redirect_to family_url(@family)
    else
      render :action => 'edit'
    end
  end

  def destroy
    Family.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
