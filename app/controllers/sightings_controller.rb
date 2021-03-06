class SightingsController < ApplicationController

  before_filter :verify_credentials, :only => [:new, :create, :edit, :update, :destroy]  
  before_filter :update_activity_timer, :except => [:new, :create, :edit, :update, :destroy]  

  def page_kind
    "trips"
  end
  
# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  def show
    @sighting = Sighting.find(params[:id])
    @page_title = @sighting.full_name

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => [@sighting], :include => [:trip, :location, :taxon] }
      format.json  { render :json => [@sighting], :include => [:trip, :location, :taxon] }
    end
  end

  def new
    @sighting = Sighting.new  
    @page_title = "New Sighting"

    if (params[:trip_id] != "")
      @sighting.trip_id = params[:trip_id]
    end
    if (params[:location_id] != "")
      @sighting.location_id = params[:location_id]
    end
  end
  
  def create
    @sighting = Sighting.new(params[:sighting])
    @page_title = "new"

    if (params[:abbreviation])
      temp = Taxon.find_by_abbreviation(params[:abbreviation])
      raise "Bogus abbreviation" if temp == nil
      @sighting.taxon_latin_name = temp.latin_name 
    elsif (params[:taxon_common_name])
      temp = Taxon.find_by_common_name(params[:taxon_common_name])
      raise "Bogus common_name" if temp == nil
      @sighting.taxon_latin_name = temp.latin_name 
    end

    if @sighting.save
      flash[:notice] = 'Sighting was successfully created.'
      expire_action :controller => 'trips', :action => 'show', :id => @sighting.trip_id
      expire_action :controller => 'trips', :action => 'edit', :id => @sighting.trip_id
      redirect_to trip_url(@sighting.trip)
    else
      render :action => 'new'
    end
  end

  def create_list 
    @page_title = "new"

    begin
      if (params[:abbreviation_list])
        @sighting = Sighting.new(params[:sighting])
        raise "Missing location" if @sighting.location_id == nil

        abbreviations = params[:abbreviation_list].scan(/\w+/)
        raise "Missing abbreviations" if abbreviations.size == 0

        bogus_abbreviations = []
        for an_abbrev in abbreviations do
          temp = Taxon.find_by_abbreviation(an_abbrev)
          bogus_abbreviations << an_abbrev if ! temp
        end

        raise "Please fix these abbreviations: " + bogus_abbreviations.join(", ") if bogus_abbreviations.size > 0

        for an_abbrev in abbreviations do
          @sighting = Sighting.new(params[:sighting])

          temp = Taxon.find_by_abbreviation(an_abbrev)
          @sighting.taxon_latin_name = temp.latin_name

          raise "Duplicate %s at %s" % [temp.common_name, @sighting.location.name] unless @sighting.valid?
          @sighting.save
        end

        flash[:notice] = 'Added ' + abbreviations.size.to_s + ' species.'
      end

      expire_action :controller => 'trips', :action => 'show', :id => @sighting.trip_id
      expire_action :controller => 'trips', :action => 'edit', :id => @sighting.trip_id
      redirect_to trip_url(@sighting.trip_id)    

    rescue Exception => exc
      flash[:error] = exc.message
      logger.error(exc.message)
      flash[:abbreviations] = params[:abbreviation_list]    
      flash[:location_id] = @sighting.location_id
      redirect_to :back
    end  
  end                            

  def edit
    @sighting = Sighting.find(params[:id])
    @page_title = @sighting.full_name
    @all_trips = Trip.find(:all, :order => 'date')
    @all_locations = Location.find(:all, :order => 'name')

    respond_to do |format|
      format.html # edit.html.erb
      format.json  { render :json => { :sighting => @sighting.as_json(:include => :taxon), :all_trips => @all_trips, :all_locations => @all_locations } }
    end
  end

  def update
    @sighting = Sighting.find(params[:id])

    if (params[:abbreviation])
      temp = Taxon.find_by_abbreviation(params[:abbreviation])
      raise "Bogus abbreviation" if temp == nil
      @sighting.taxon_latin_name = temp.latin_name 
    elsif (params[:taxon_common_name])
      temp = Taxon.find_by_common_name(params[:taxon_common_name])
      raise "Bogus common_name" if temp == nil
      @sighting.taxon_latin_name = temp.latin_name 
    end

    @page_title = @sighting.full_name

    if @sighting.update_attributes(params[:sighting])
      flash[:notice] = 'Sighting was successfully updated.'
      expire_action :controller => 'trips', :action => 'show', :id => @sighting.trip_id
      expire_action :controller => 'trips', :action => 'edit', :id => @sighting.trip_id
      redirect_to trip_url(@sighting.trip)
    else
      render edit_sighting_url(@sighting)
    end
  end

  def edit_individual
    @sightings = Sighting.find(params[:sighting_ids])
    @page_title = 'Edit %d sightings' % @sightings.length
  end

  def update_individual
    @sightings = Sighting.update(params[:sightings].keys, params[:sightings].values)
    flash[:notice] = "Sightings updated"
    redirect_to trip_url(@sightings[0].trip_id)
  end

  def destroy
    @sighting = Sighting.find(params[:id])
    @sighting.destroy
    expire_action :controller => 'trips', :action => 'show', :id => @sighting.trip_id
    expire_action :controller => 'trips', :action => 'edit', :id => @sighting.trip_id
    redirect_to trip_url(@sighting.trip_id)
  end
end
