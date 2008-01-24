class SightingsController < ApplicationController
  auto_complete_for :species, :common_name
 
# here's the autocomplete voodoo, put this in someplace, some time 
#  <p>
# <%= text_field_with_auto_complete :species, :common_name %>
#  </p>  

  def page_kind
    "trip"
  end
  
# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  def show
    @sighting = Sighting.find(params[:id])
    
    @sighting.previous && @previous_url = sighting_url(@sighting.previous)
    @sighting.next && @next_url = sighting_url(@sighting.next)
  end

  def new
    @sighting = Sighting.new
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
      
      raise "Bogus abbreviations: " + bogus_abbreviations.join(", ") if bogus_abbreviations.size > 0
      
      for an_abbrev in abbreviations do
        @sighting = Sighting.new(params[:sighting])
        temp = Species.find_by_abbreviation(an_abbrev)
        @sighting.species_id = temp.id  
        @sighting.save
      end

      flash[:notice] = 'Added ' + abbreviations.size.to_s + ' species.'
    end

    redirect_to edit_trip_url(@sighting.trip_id)
  end

  def edit
    @sighting = Sighting.find(params[:id])
  end

  def update
    @sighting = Sighting.find(params[:id])
    if @sighting.update_attributes(params[:sighting])
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
  
  def autocomplete_species
      @species_list = Species.find(:all, :conditions => ["common_name like ?", "%#{params[:sighting][:species]}%"])
  end
end
