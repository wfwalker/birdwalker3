class FamiliesController < ApplicationController
  helper :species
  helper :trips
  helper :locations
  helper :sightings
  
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
    @families = Family.find_all_seen
  end

  def show
    @family = Family.find(params[:id])
    
    @family.previous && @previous_url = family_url(@family.previous)
    @family.next && @next_url = family_url(@family.next)
  end

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(params[:family])
    if @family.save
      flash[:notice] = 'Family was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @family = Family.find(params[:id])
  end

  def update
    @family = Family.find(params[:id])
    if @family.update_attributes(params[:family])
      flash[:notice] = 'Family was successfully updated.'
      redirect_to :action => 'show', :id => @family
    else
      render :action => 'edit'
    end
  end

  def destroy
    Family.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
