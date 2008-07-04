class BirdWalkerController < ApplicationController
  helper :trips
  helper :species
  helper :locations
  helper :counties
  helper :sightings
  helper :photos
  
  def index
    @recent_trips = Trip.find(:all, :limit => 8, :order => 'date DESC')
    @most_visited_locations = Location.most_visited_recently
    @bird_of_the_week = Species.bird_of_the_week
    @photo_of_the_week = @bird_of_the_week.photo_of_the_week
    @this_year_species = Species.year_to_date(Date.today.year)
    @last_year_species = Species.year_to_date(Date.today.year - 1)
  end

  def index_rss
    @recent_trips = Trip.find(:all, :limit => 10, :order => 'date DESC')
    @bird_of_the_week = Species.bird_of_the_week
    @photo_of_the_week = @bird_of_the_week.photo_of_the_week
    @this_year_species = Species.year_to_date(Date.today.year)
    @last_year_species = Species.year_to_date(Date.today.year - 1)  
    
    render_without_layout :file => 'app/views/bird_walker/index_rss.rxml'
      @headers["Content-Type"] = "application/xml"  
    end

  def about
  end
  
  def login
    if (params[:username] != nil && params[:password] != nil) then
        aUser = User.find_by_name(params[:username])  
        if (aUser != nil && aUser.password == params[:password]) then
          logger.error("Logging in as  " + aUser.name)
          flash[:notice] = 'Welcome back, ' + aUser.name
          session[:username] = aUser.name    
        else
          logger.error("Failed login attempt")
          flash[:notice] = 'Incorrect login or password; please try again'
          session[:username] = nil    
        end
    end
  end
  
  def photo_search
    where_clause = "SELECT photos.* from photos, species, trips, locations, counties WHERE photos.trip_id=trips.id AND photos.location_id=locations.id AND photos.species_id=species.id AND locations.county_id=counties.id "
    do_search = false
    
    if (params[:photo] != nil && params[:photo][:species_id] != "") then
      where_clause = where_clause + " AND photos.species_id='" + params[:photo][:species_id].to_s + "'"
      do_search = true
    end
    if (params[:photo] != nil && params[:photo][:location_id] != "") then
      where_clause = where_clause + " AND photos.location_id='" + params[:photo][:location_id].to_s + "'"
      do_search = true
    end
    if (params[:species] != nil && params[:species][:family_id] != "") then
      where_clause = where_clause + " AND species.family_id='" + params[:species][:family_id].to_s + "'"
      do_search = true
    end
    if (params[:location] != nil && params[:location][:county_id] != "") then
      where_clause = where_clause + " AND locations.county_id='" + params[:location][:county_id].to_s + "'"
      do_search = true
    end
    if (params[:county] != nil && params[:county][:state_id] != "") then
      where_clause = where_clause + " AND counties.state_id='" + params[:county][:state_id].to_s + "'"
      do_search = true
    end
    if (params[:date] != nil && params[:date][:month] != "") then
      where_clause = where_clause + " AND MONTH(trips.date)='" + params[:date][:month].to_s + "'"
      do_search = true
    end
    if (params[:date] != nil && params[:date][:year] != "") then
      where_clause = where_clause + " AND YEAR(trips.date)='" + params[:date][:year].to_s + "'"
      do_search = true
    end
    if (params[:photo] != nil && params[:photo][:rating] != "") then
      where_clause = where_clause + " AND photos.rating='" + params[:photo][:rating].to_s + "'"
      do_search = true
    end
    
    if (do_search) then
      @found_photos = Photo.find_by_sql(where_clause);
    end
  end
  
  def search
    if (params[:terms] != nil) then
      logger.error("searching for  " + params[:terms])
      
      @found_counties = County.find(:all, :conditions => ["name like ?", "%#{params[:terms]}%"], :order => "id")
      @found_species = Species.find_by_sql("SELECT DISTINCT species.* FROM species, sightings WHERE sightings.species_id=species.id AND species.common_name LIKE '%#{params[:terms]}%' ORDER BY species.id")
      @found_trips = Trip.find(:all, :conditions => ["name like ?", "%#{params[:terms]}%"], :order => "id")
      @found_locations = Location.find(:all, :conditions => ["name like ?", "%#{params[:terms]}%"], :order => "id")
      @terms = params[:terms]
    else
      @terms = "terms"
    end
  end
  
  def logout
    if (session[:username] != nil) then
      logger.error("Logging out")
      flash[:notice] = 'Logged out'
      session[:username] = nil    
    end
    
    render :action => 'login'
  end
  
  def page_kind
    "home"
  end
end
