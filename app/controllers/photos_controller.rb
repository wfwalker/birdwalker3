class PhotosController < ApplicationController
  helper :locations

  before_filter :verify_credentials, :only => [:edit, :update, :update_rating, :destroy]  
  before_filter :update_activity_timer, :except => [:edit, :update, :update_rating, :destroy]  

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
    @page_title = @photo.species.common_name
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @photo.to_xml(:methods => [ :photo_URL ]) }
      format.json  { render :json => [@photo], :methods => :image_filename }
    end
  end

  def show_by_date
    foundDate = Date.new(params["year"].to_i(10), params["month"].to_i(10), params["day"].to_i(10))
    foundTrip = Trip.find_by_date(foundDate)
    raise "missing trip" unless foundTrip

    foundSpecies = Species.find_by_abbreviation(params[:abbreviation])
    raise "missing species" unless foundSpecies

    foundOriginalFilename = params[:originalfilename]
    raise "missing original filename" unless foundOriginalFilename

    foundPhotos = Photo.find_all_by_trip_id(foundTrip.id).select { | a_photo |
      (a_photo.species_id == foundSpecies.id) && (a_photo.original_filename == foundOriginalFilename)
    }

    @photo = foundPhotos[0]

    if (not @photo) then
      raise "missing photo for trip " + foundTrip.id.to_s
    end

    @page_title = @photo.species.common_name

    respond_to do |format|
      format.html { render :action => 'show' }
      format.xml  { render :xml => @photo.to_xml() }
      format.json  { render :json => @photo.to_json() }
    end
  end

  def recent_gallery
    @location_galleries = Location.find_by_sql("
      SELECT locations.*, count(DISTINCT photos.id) as photo_count
        FROM locations, photos
        WHERE photos.location_id=locations.id AND photos.rating > 3
        GROUP BY locations.id ORDER BY photo_count DESC LIMIT 20");

    @recent_gallery_photos = Photo.recent(2 * Photo.default_gallery_size())
    @page_title = "recent"
  end            
  
  def recent_gallery_rss
    @recent_gallery_photos = Photo.recent(2 * Photo.default_gallery_size())
    
    render :layout => false, :file => 'app/views/photos/recent_gallery_rss.rxml'
    headers["Content-Type"] = "application/xml"  
  end

  def new
    @photo = Photo.new  
    @page_title = "new"
    
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
    @page_title = "new"

    if (params[:abbreviation])
      temp = Species.find_by_abbreviation(params[:abbreviation])
      raise "Bogus abbreviation" if temp == nil
      @photo.species_id = temp.id  
    end

    if @photo.save
      flash[:notice] = 'Photo was successfully created.'         
      expire_action :controller => 'trips', :action => 'show', :id => @photo.trip_id
      redirect_to edit_trip_url(@photo.trip_id)
    else
      render :action => 'new'
    end
  end
  
  def create_list
    @page_title = "new"

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
    @page_title = @photo.species.common_name
  end

  def update
    @photo = Photo.find(params[:id])
    @page_title = @photo.species.common_name

    if @photo.update_attributes(params[:photo])
      flash[:error] = 'Photo was successfully updated.'
      expire_action :controller => 'trips', :action => 'show', :id => @photo.trip_id
      redirect_to photo_url(@photo)
    else
      render :action => 'edit'
    end
  end

  def update_rating
    @photo = Photo.find(params[:id])
    @page_title = @photo.species.common_name

    @photo.rating = params[:rating]
    @photo.save
    expire_action :controller => 'trips', :action => 'show', :id => @photo.trip_id
    render :action => 'show'
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    expire_action :controller => 'trips', :action => 'show', :id => @photo.trip_id
    redirect_to edit_trip_url(@photo.trip_id)
  end
  
  def gallery_page_size()
	  10
  end  
end

