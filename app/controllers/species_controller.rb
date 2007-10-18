class SpeciesController < ApplicationController
  helper :trips
  helper :locations
  layout "standard"

  def isLocation
    false
  end
  
  def isTrip
    false
  end
  
  def isSpecies
    true
  end

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @allspecies = Species.find_all_seen
    @page_title = "Species"
  end

  def show
    @species = Species.find(params[:id])
    @page_title = @species.common_name
  end

  def new
    @species = Species.new
    @page_title = "New Species"
  end

  def create
    @species = Species.new(params[:species])
    if @species.save
      flash[:notice] = 'Species was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @species = Species.find(params[:id])
    @page_title = @species.common_name
  end

  def update
    @species = Species.find(params[:id])
    if @species.update_attributes(params[:species])
      flash[:notice] = 'Species was successfully updated.'
      redirect_to :action => 'show', :id => @species
    else
      render :action => 'edit'
    end
  end

  def destroy
    Species.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
