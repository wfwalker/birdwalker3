class PhotosController < ApplicationController
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
    @photo = Photo.find(params[:id])
    
    @photo.previous && @previous_url = photo_url(@photo.previous)
    @photo.next && @next_url = photo_url(@photo.next)
    
    render :action => 'show', :layout => 'gallery'
  end

  def new
    @photo = Photo.new  
    
    if (! is_editing_allowed?) then
      flash[:notice] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    end
  
    if (params[:trip_id] != "")
      @photo.trip_id = params[:trip_id]
    end
    if (params[:location_id] != "")
      @photo.location_id = params[:location_id]
    end
  end
  
  def create
    @photo = Photo.new(params[:photo])

    if (params[:abbreviation])
      temp = Species.find_by_abbreviation(params[:abbreviation])
      raise "Bogus abbreviation" if temp == nil
      @photo.species_id = temp.id  
    end

    if @photo.save
      flash[:notice] = 'Photo was successfully created.'
      redirect_to edit_trip_url(@photo.trip_id)
    else
      render :action => 'new'
    end
  end
  
  def create_list
    if (params[:abbreviation_list])
      @photo = Photo.new(params[:photo])
      raise "Missing location" if @photo.location_id == nil
      
      abbreviations = params[:abbreviation_list].scan(/\w+/)
      raise "Missing abbreviations" if abbreviations.size == 0

      bogus_abbreviations = []
      for an_abbrev in abbreviations do
        temp = Species.find_by_abbreviation(an_abbrev)
        bogus_abbreviations << an_abbrev if ! temp
      end
      
      raise "Bogus abbreviations: " + bogus_abbreviations.join(", ") if bogus_abbreviations.size > 0
      
      for an_abbrev in abbreviations do
        @photo = Photo.new(params[:photo])
        temp = Species.find_by_abbreviation(an_abbrev)
        @photo.species_id = temp.id  
        @photo.save
      end

      flash[:notice] = 'Added ' + abbreviations.size.to_s + ' species.'
    end

    redirect_to edit_trip_url(@photo.trip_id)
  end

  def edit
    @photo = Photo.find(params[:id])

    if (! is_editing_allowed?) then
      flash[:notice] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    end
  end

  def update
    @photo = Photo.find(params[:id])

    if (! is_editing_allowed?) then
      flash[:notice] = 'Editing not allowed.'
      redirect_to :controller => 'bird_walker', :action => 'login'
    elsif @photo.update_attributes(params[:photo])
      flash[:notice] = 'Photo was successfully updated.'
      redirect_to photo_url(@photo)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to edit_trip_url(@photo.trip_id)
  end
  
  def autocomplete_species
      @species_list = Species.find(:all, :conditions => ["common_name like ?", "%#{params[:photo][:species]}%"])
  end
end
