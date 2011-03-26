require 'net/http'
require 'uri'
require "rexml/document"
require "rexml/element"
require "rexml/xmldecl"
require "rexml/text"
include REXML

class LocationsController < ApplicationController
  helper :trips
  helper :species
  helper :sightings
  helper :photos
  
  before_filter :verify_credentials, :only => [:new, :create, :edit, :update, :destroy]  
  before_filter :update_activity_timer, :except => [:new, :create, :edit, :update, :destroy]  
  
  caches_action :list, :index, :show, :layout => false
  
  def page_kind
    "locations"
  end

  def list
    @page_title = "Locations"
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
    @page_title = @location.name
  end

  def recent_nearby_ebird_sightings
    @location = Location.find(params[:id])    
    render :json => @location.recent_nearby_ebird_sightings
  end      
  
  def locations_near
    @locations = Location.locations_near(params[:lat].to_f, params[:long].to_f, params[:miles].to_i)
    render :json => @locations
  end
  
  def show
    @location = Location.find(params[:id])
    @page_title = @location.name
    
    if @location.common?
        render :action => 'show_common'
      else
        render :action => 'show_rare'
    end
  end          
  
  def show_species_by_year
    @location = Location.find(params[:id])
    @page_title = @location.name
    
    @map, @totals = Sighting.map_by_year_and_species(@location.sightings)
  end

  def show_species_by_month
    @location = Location.find(params[:id])
    @page_title = @location.name
    
    @map, @totals = Sighting.map_by_month_and_species(@location.sightings)
  end

  def new
    @location = Location.new
    @page_title = "new"
  end

  def create
    @location = Location.new(params[:location])
    @page_title = "new"

    if @location.save
      flash[:notice] = 'Location was successfully created.'
      redirect_to location_url(@location)
      expire_action :action => :list
      expire_action :action => :index
    else
      render :action => 'new'
    end
  end

  def edit
    @location = Location.find(params[:id])
    @page_title = @location.name
  end

  def update
    @location = Location.find(params[:id])
    @page_title = @location.name

    expire_action :action => :show

    if @location.update_attributes(params[:location])
      flash[:notice] = 'Location was successfully updated.'
      redirect_to location_url(@location)
    else
      render :action => 'edit'
    end
  end

  def destroy
    Location.find(params[:id]).destroy
    expire_action :action => :list
    expire_action :action => :index
    redirect_to :action => 'list'
  end
end
