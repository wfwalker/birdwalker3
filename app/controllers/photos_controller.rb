class PhotosController < ApplicationController

  before_filter :verify_credentials, :only => [:new, :create, :edit, :update, :update_rating, :destroy]  
  before_filter :update_activity_timer, :except => [:new, :create, :edit, :update, :update_rating, :destroy]  

  def page_kind
    "photos"
  end
  
# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }
 
  def index       
    @location_galleries = Location.find_by_sql("
      SELECT locations.*, count(DISTINCT photos.id) as photo_count
        FROM locations, photos
        WHERE photos.location_id=locations.id AND photos.rating > 3
        GROUP BY locations.id ORDER BY photo_count DESC LIMIT 20");
  end
          
  def show
    @photo = Photo.find(params[:id])
    render :action => 'show'
  end

  def recent_gallery
    @recent_gallery_photos = Photo.find_recent_gallery

    if params[:featured_photo_id] != nil then
      @featured_photo = Photo.find(params[:featured_photo_id])
    else
      @featured_photo = @recent_gallery_photos[0]
    end

    if params[:start_index] != nil then
      @start_index = params[:start_index].to_i
    else
      @start_index = 0
    end

    @end_index = @start_index + gallery_page_size() - 1
    
    render :action => 'recent_gallery', :collection => @recent_gallery_photos
  end            
  
  def recent_gallery_rss
    @recent_gallery_photos = Photo.find_recent_gallery   
    
    render :layout => false, :file => 'app/views/photos/recent_gallery_rss.rxml'
    headers["Content-Type"] = "application/xml"  
  end

  def new
    @photo = Photo.new  
    
    if (params[:trip_id] != "")
      @photo.trip_id = params[:trip_id]
    end
    if (params[:location_id] != "")
      @photo.location_id = params[:location_id]
    end
    if (params[:species_id] != "")
      @photo.species_id = params[:species_id]
    end
    if (params[:original_filename] != "")
      @photo.original_filename = params[:original_filename]
    end
    if (params[:rating] != "")
      @photo.rating = params[:rating]
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
  end

  def update
    @photo = Photo.find(params[:id])

    if @photo.update_attributes(params[:photo])
      flash[:error] = 'Photo was successfully updated.'
      redirect_to photo_url(@photo)
    else
      render :action => 'edit'
    end
  end

  def update_rating
    @photo = Photo.find(params[:id])
    @photo.rating = params[:rating]
    @photo.save
    render :action => 'show'
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to edit_trip_url(@photo.trip_id)
  end
  
  def gallery_page_size()
	  10
  end  
end

