require 'ebird_api'
require 'net/http'
require 'uri'
require "rexml/document"
require "rexml/element"
require "rexml/xmldecl"
require "rexml/text"
include REXML

class LocationsController < ApplicationController
  helper :trips
  helper :taxons
  helper :sightings
  helper :photos
  
  before_filter :verify_credentials, :only => [:new, :create, :edit, :update, :destroy]  
  before_filter :update_activity_timer, :except => [:new, :create, :edit, :update, :destroy]  
  
  # caches_action :show, :layout => false
  
  def page_kind
    "locations"
  end

  def index
    @page_title = "Birding Map"
    @locations = Location.find_by_county_and_state
    @most_visited_locations = Location.most_visited_recently

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locations }
      format.json  { render :json => @locations, :include => [:county, :trips ] }
    end
  end

  def photo_metadata          
    @location = Location.find(params[:id])
    photoDataList = @location.photos.collect { |photo|
      {
        "imageTitle" => photo.taxon.common_name, 
        "imgUrl" => photo.thumb_URL("birdwalker.com"),
        "launchUrl" => photo_url(photo)
      }
    }
    render :json => photoDataList
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
    
    if params[:dist] then
      render :json => @location.recent_nearby_ebird_sightings(params[:dist]) 
    else
      render :json => @location.recent_nearby_ebird_sightings()
    end
  end      
  
  def locations_near
    @locations = Location.locations_near(params[:lat].to_f, params[:long].to_f, params[:miles].to_i)
    render :json => @locations
  end
  
  def show
    @location = Location.find(params[:id])
    @page_title = @location.name

    respond_to do |format|
      format.html # show.rhtml
      # TODO: cant include :county => { :include => [ :state ] }
      format.json  { render json: [@location.as_json(:include => { :taxons => {}, :trips => {}, :county => { :include => [ :state ] }, :photos => { :include => [ :taxon, :trip, :location ], :methods => [ :photo_URL ] } } ) ] }
    end
  end          
  
  def show_chronological_list
    @location = Location.find(params[:id])
    @page_title = @location.name
    @life_sightings = @location.sightings.life
  end

  def show_species_by_year
    @location = Location.find(params[:id])
    @page_title = @location.name
    
    @map, @totals = Sighting.map_by_year_and_taxon(@location.sightings)
  end

  def show_species_by_month
    @location = Location.find(params[:id])
    @page_title = @location.name
    
    @map, @totals = Sighting.map_by_month_and_taxon(@location.sightings)
  end
  
  def photo_to_do_list
    @location = Location.find(params[:id])
    @page_title = "Photo TODO List"
    @all_taxons_photographed = Taxon.photographed
    @taxons_seen_nearby = @location.taxons_seen_nearby(40)
    @taxons_seen_not_photographed_nearby = @taxons_seen_nearby - @all_taxons_photographed
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

    @all_counties = County.find(:all, :order => 'name')

    respond_to do |format|
      format.html # edit.html.erb
      format.json  { render :json => { :location => @location, :all_counties => @all_counties } }
    end    
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
