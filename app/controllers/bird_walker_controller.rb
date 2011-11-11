require "open-uri"   

class BirdWalkerController < ApplicationController
  helper :trips
  helper :species
  helper :locations
  helper :counties
  helper :sightings
  helper :photos    
  
  before_filter :update_activity_timer, :except => [:login, :logout]  
  
  def page_kind                                 
    if request.path_parameters[:action] == "about"
      "about"
    else
      "home"
    end
  end
  
  def index
    @bird_of_the_week = Species.bird_of_the_week                  
    
    @recent_photos = Photo.recent(15)
    @most_visited_locations = Location.most_visited_recently
    @recent_trips = Trip.find(:all, :limit => 8, :order => 'date DESC')
    
    @this_year_species = Species.year_to_date(Date.today.year)
    @last_year_species = Species.year_to_date(Date.today.year - 1)
  end      
  
  def photographer
    @recent_gallery_photos = Photo.recent(2 * Photo.default_gallery_size())
    render :layout => false, :file => 'app/views/bird_walker/photographer.rhtml'
  end
  
  def webapp_manifest
    manifest = {}
    
    manifest["version"] = "1.0"
    manifest["name"] = "BirdWalker"
    manifest["description"] = "Photographs and Field Notes from Bill Walker"
    manifest["icons"] = {"128" => "/images/birdwalker-logo-128.png"}
    manifest["widget"] = {"path" => "/bird_walker/webapp_widget", "width" => 200, "height" => 100}
    manifest["default_locale"] = "en"
    manifest["installs_allowed_from"] = ["https://appstore.mozillalabs.com", "https://addons.mozilla.org", "https://addons-dev.allizom.org"]
    manifest["developer"] = {"name" => "Bill Walker", "url" => "http://birdwalker.com"}
    
    render :json => manifest
    headers["Content-type"] = "application/x-web-app-manifest+json"
  end
  
  def webapp_install
    @page_title = "Install birdwalker.com Mozilla App"
  end
  
  def webapp_widget
    @bird_of_the_week = Species.bird_of_the_week 
    @recent_gallery_photos = Photo.recent(2 * Photo.default_gallery_size())
    render :layout => false, :file => 'app/views/bird_walker/webapp_widget.rhtml'
  end

  def index_rss
    @recent_trips = Trip.find(:all, :limit => 10, :order => 'date DESC')     
    
    @bird_of_the_week = Species.bird_of_the_week 

    @this_year_species = Species.year_to_date(Date.today.year)
    @last_year_species = Species.year_to_date(Date.today.year - 1)  
    
    @http_host = request.headers['Host']
    
    render :layout => false, :file => 'app/views/bird_walker/index_rss.rxml'
    headers["Content-Type"] = "application/xml"  
  end   
    
  def about
    @page_title = "About"
  end
  
  def login
    if (params[:username] != nil && params[:password] != nil) then
        aUser = User.find_by_name(params[:username])  
        if (aUser != nil && aUser.password == params[:password]) then
          logger.error("VC: Logging in as  " + aUser.name)
          flash[:notice] = 'Welcome back, ' + aUser.name
          session[:username] = aUser.name  
          session[:login_time] = Time.now.to_i     
          Rails.cache.clear
          redirect_to :action => 'index'  
        else
          logger.error("VC: Failed login attempt")
          flash[:error] = 'Incorrect login or password; please try again'
          session[:username] = nil    
          session[:login_time] = nil
        end
    end
  end    
  
  def verify_browserid
    if (params[:assertion])                     
      # now post to https://browserid.org/verify with two POST args, assertion and audience
      
      url = URI.parse('https://browserid.org/verify')                       
      http = Net::HTTP.new(url.host, url.port)

      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({'assertion' => params[:assertion], 'audience' => 'birdwalker.com'})
      res = http.start {|http| http.request(req) } 
                                                                
      # results should be JSON like result {"status":"okay","email":"walker@shout.net","audience":"localhost:3000","valid-until":1313649622973,"issuer":"browserid.org:443"}
      
      parsedResults = ActiveSupport::JSON.decode(res.body())  
      
      if parsedResults["status"] == "okay" and parsedResults["email"] == "walker@shout.net"
        logger.error("VC: Logging in as " + parsedResults["email"])
        flash[:notice] = 'Welcome back, ' + parsedResults["email"]
        session[:username] = parsedResults["email"] 
        session[:login_time] = Time.now.to_i     
        Rails.cache.clear   
        render :text => '', :layout => false, :status => 200    
      else
        logger.error("VC: no editing priviledges for " + parsedResults["email"])
        flash[:error] = 'No editing priviledges for ' + parsedResults["email"]
        session[:username] = nil    
        session[:login_time] = nil 
        render :text => '', :layout => false, :status => 500
      end
    else
      logger.error("VC: Failed login attempt")
      flash[:error] = 'Incorrect login or password; please try again'
      session[:username] = nil    
      session[:login_time] = nil 
      render :text => '', :layout => false, :status => 500
    end
  end
  
  def photo_search
    @page_title = "photo search results"

    base_where_clause = "SELECT photos.* from photos, species, trips, locations, counties WHERE photos.trip_id=trips.id AND photos.location_id=locations.id AND photos.species_id=species.id AND locations.county_id=counties.id "
    additional_where_clause = " "
    do_search = false
    
    if (params[:photo] != nil && params[:photo][:species_id] != "") then
      additional_where_clause = additional_where_clause + " AND photos.species_id='" + params[:photo][:species_id].to_s + "'"
      do_search = true
    end
    if (params[:photo] != nil && params[:photo][:location_id] != "") then
      additional_where_clause = additional_where_clause + " AND photos.location_id='" + params[:photo][:location_id].to_s + "'"
      do_search = true
    end
    if (params[:species] != nil && params[:species][:family_id] != "") then
      additional_where_clause = additional_where_clause + " AND species.family_id='" + params[:species][:family_id].to_s + "'"
      do_search = true
    end
    if (params[:photo] != nil && params[:photo][:county_id] != "") then
      additional_where_clause = additional_where_clause + " AND locations.county_id='" + params[:photo][:county_id].to_s + "'"
      do_search = true
    end
    if (params[:county] != nil && params[:county][:state_id] != "") then
      additional_where_clause = additional_where_clause + " AND counties.state_id='" + params[:county][:state_id].to_s + "'"
      do_search = true
    end
    if (params[:date] != nil && params[:date][:month] != "") then
      additional_where_clause = additional_where_clause + " AND MONTH(trips.date)='" + params[:date][:month].to_s + "'"
      do_search = true
    end
    if (params[:date] != nil && params[:date][:year] != "") then
      additional_where_clause = additional_where_clause + " AND YEAR(trips.date)='" + params[:date][:year].to_s + "'"
      do_search = true
    end
    if (params[:photo] != nil && params[:photo][:rating] != "") then
      additional_where_clause = additional_where_clause + " AND photos.rating='" + params[:photo][:rating].to_s + "'"
      do_search = true
    end            
    
    logger.error("\n\n*** where clause for photo search " + additional_where_clause + "\n\n\n")
    
    if (do_search) then
      @found_photos = Photo.find_by_sql(base_where_clause + additional_where_clause);
    end
  end
  
  def search
    @page_title = "search results"
    if (params[:terms] != nil && params[:terms].length > 0) then
      @found_counties = County.find(:all, :conditions => ["name like ?", "%#{params[:terms]}%"], :order => "id")
      @found_species = Species.find_by_sql(["SELECT DISTINCT species.* FROM species, sightings WHERE sightings.species_id=species.id AND species.common_name LIKE ? ORDER BY species.id", "%#{params[:terms]}%"])

      #for trips, look in both the trip names and the notes, removing duplicates
      @found_trips = Trip.find(:all, :conditions => ["name like ?", "%#{params[:terms]}%"], :order => "id") | Trip.find(:all, :conditions => ["notes like ?", "%#{params[:terms]}%"], :order => "id")

      @found_locations = Location.find(:all, :conditions => ["name like ?", "%#{params[:terms]}%"], :order => "id")
      @terms = params[:terms]

      if ((@found_species.size + @found_counties.size + @found_trips.size + @found_locations.size) == 1) then    
	    if (@found_species.size == 1) then
          redirect_to :controller => 'species', :action => 'show', :id => @found_species[0]       
      	elsif (@found_counties.size == 1) then
          redirect_to :controller => 'counties', :action => 'show', :id => @found_counties[0]       
        elsif (@found_trips.size == 1) then
          redirect_to :controller => 'trips', :action => 'show', :id => @found_trips[0]       
        elsif (@found_locations.size == 1) then
          redirect_to :controller => 'locations', :action => 'show', :id => @found_locations[0]       
        end
      end
    else
      @terms = "terms"
    end           
  end
  
  def logout
    if (session[:username] != nil) then
      logger.error("VC: Logging out")
      flash[:notice] = 'Logged out'
      Rails.cache.clear
      session[:username] = nil    
      session[:login_time] = nil
    end
    
    redirect_to :action => 'index'  
  end
end
