class StatesController < ApplicationController
  helper :trips            
  helper :sightings
  helper :taxons
  helper :locations
  helper :photos

  before_filter :update_activity_timer  
  
  # caches_action :list, :index, :show, :layout => false

  def page_kind
    "locations"
  end
  
  def show
    @state = State.find(params["id"])
    @page_title = @state.name

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @state }
      format.json  { render :json => @state }
    end
  end
  
  def locations
    @state = State.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @state.locations }
      format.json  { render :json => @state.locations }
    end
  end

  def show_chronological_list
    @state = State.find(params["id"])
    @page_title = @state.name
    @life_sightings = @state.sightings.life
  end

  def show_species_by_year
    @state = State.find(params["id"])
    @page_title = @state.name
    
    @map, @totals = Sighting.map_by_year_and_taxon(@state.sightings)
  end

  def show_species_by_month
    @state = State.find(params["id"])
    @page_title = @state.name
    
    @map, @totals = Sighting.map_by_month_and_taxon(@state.sightings)
  end
  
  def new
    @state = State.new
    @page_title = "new"
  end

  def create
    @state = State.new(params[:state])
    @page_title = "new"

    if @state.save
      flash[:notice] = 'State was successfully created.'
      redirect_to state_url(@state)
    else
      render :action => 'new'
    end
  end        
  
  def edit
    @state = State.find(params[:id])
    @page_title = @state.name
  end

  def update
    @state = State.find(params[:id])
    @page_title = @state.name

    if @state.update_attributes(params[:state])
      flash[:notice] = 'State was successfully updated.'
      redirect_to state_url(@state)
    else
      render :action => 'edit'
    end
  end    

  def destroy
    State.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
    
  def index
    list
    @page_title = "States"
    render :action => 'list'
  end
  
  def list
    @page_title = "States"
    @states = State.find(:all)
  end
end
