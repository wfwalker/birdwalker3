class SightingsController < ApplicationController
  auto_complete_for :species, :common_name
 
# here's the autocomplete voodoo, put this in someplace, some time 
#  <p>
# <%= text_field_with_auto_complete :species, :common_name %>
#  </p>  

  def page_kind
    "trips"
  end
  
# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  def show
    @sighting = Sighting.find(params[:id])
  end

  def new
    @sighting = Sighting.new  
    
    if (! is_editing_allowed?) then
      flash[:error] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    end
  
    if (params[:trip_id] != "")
      @sighting.trip_id = params[:trip_id]
    end
    if (params[:location_id] != "")
      @sighting.location_id = params[:location_id]
    end
  end
  
  def create
    @sighting = Sighting.new(params[:sighting])

    if (params[:abbreviation])
      temp = Species.find_by_abbreviation(params[:abbreviation])
      raise "Bogus abbreviation" if temp == nil
      @sighting.species_id = temp.id  
    end

    if @sighting.save
      flash[:notice] = 'Sighting was successfully created.'
      redirect_to edit_trip_url(@sighting.trip_id)
    else
      render :action => 'new'
    end
  end

  def create_list 
    begin
      if (params[:abbreviation_list])
        @sighting = Sighting.new(params[:sighting])
        raise "Missing location" if @sighting.location_id == nil

        abbreviations = params[:abbreviation_list].scan(/\w+/)
        raise "Missing abbreviations" if abbreviations.size == 0

        bogus_abbreviations = []
        for an_abbrev in abbreviations do
          temp = Species.find_by_abbreviation(an_abbrev)
          bogus_abbreviations << an_abbrev if ! temp
        end

        raise "Please pick your location again and fix these abbreviations: " + bogus_abbreviations.join(", ") if bogus_abbreviations.size > 0

        for an_abbrev in abbreviations do
          @sighting = Sighting.new(params[:sighting])
          temp = Species.find_by_abbreviation(an_abbrev)
          @sighting.species_id = temp.id  
          @sighting.save
        end

        flash[:notice] = 'Added ' + abbreviations.size.to_s + ' species.'
      end

      redirect_to edit_trip_url(@sighting.trip_id)    

    rescue Exception => exc
      flash[:error] = exc.message
      flash[:abbreviations] = params[:abbreviation_list]
      redirect_to :back
    end  
  end                            

  def edit
    @sighting = Sighting.find(params[:id])

    if (! is_editing_allowed?) then
      flash[:error] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    end
  end

  def update
    @sighting = Sighting.find(params[:id])

    if (! is_editing_allowed?) then
      flash[:error] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    elsif @sighting.update_attributes(params[:sighting])
      flash[:notice] = 'Sighting was successfully updated.'
      redirect_to edit_trip_url(@sighting.trip_id)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @sighting = Sighting.find(params[:id])
    @sighting.destroy
    redirect_to edit_trip_url(@sighting.trip_id)
  end
end
