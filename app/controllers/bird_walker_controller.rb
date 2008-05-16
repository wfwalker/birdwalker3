class BirdWalkerController < ApplicationController
  helper :trips
  helper :species
  helper :locations
  helper :sightings
  
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
  
  def search
    if (params[:terms] != nil) then
      logger.error("searching for  " + params[:terms])
      
      @found_species = Species.find(:all, :conditions => ["common_name like ?", "%#{params[:terms]}%"], :order => "id")
      @found_trips = Trip.find(:all, :conditions => ["name like ?", "%#{params[:terms]}%"], :order => "id")
      @found_locations = Location.find(:all, :conditions => ["name like ?", "%#{params[:terms]}%"], :order => "id")
      @found_sightings = Sighting.find(:all, :conditions => ["notes like ?", "%#{params[:terms]}%"], :order => "id")
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
