require 'net/http'
require "rexml/document"
require "rexml/element"
require "rexml/xmldecl"
require "rexml/text"
include REXML

class BirdWalkerController < ApplicationController
  helper :trips
  helper :taxons
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
    @bird_of_the_week = Taxon.bird_of_the_week
    
    @all_taxons_photographed = Taxon.photographed
    @taxons_by_family = Taxon.map_by_family(@all_taxons_photographed)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => {
          :bird_of_the_week => @bird_of_the_week.as_json(:include => { :photos => { :include => [ :trip, :location ], :methods => [ :photo_URL ] } } ),
          :recent_photos => @recent_photos, 
          :recent_trips => @recent_trips.as_json(:include => { :taxons => {}, :photos => { :methods => [ :thumb_URL ] } } ), 
          :this_year_species => @this_year_species,
          :last_year_species => @last_year_species,
          :day_of_year => Date.today.yday,
          :year => Date.today.year
        } 
      }
    end    
  end      
  
  def quartet
    redirect_to "http://birdwalker.com:9090/quartet.html"
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
    manifest["default_locale"] = "en"
    manifest["installs_allowed_from"] = ["*"]
    manifest["developer"] = {"name" => "Bill Walker", "url" => "http://birdwalker.com"}
    
    render :json => manifest, :content_type => "application/x-web-app-manifest+json"
  end
  
  def webapp_install
    @page_title = "Install birdwalker.com Mozilla App"
  end
  
  def index_rss
    @recent_trips = Trip.find(:all, :limit => 10, :order => 'date DESC')     
    
    @bird_of_the_week = Taxon.bird_of_the_week 

    @this_year_species = Taxon.year_to_date(Date.today.year)
    @last_year_species = Taxon.year_to_date(Date.today.year - 1)  
    
    @http_host = request.headers['Host']
    
    render :layout => false, :file => 'app/views/bird_walker/index_rss.xml.erb', :content_type => "application/xml"  
  end   
    
  def about
    @page_title = "About"
  end
  
  def login
    aUser = User.find_by_name('walker')  

    logger.error("VC: Logging in as  " + aUser.name)
    flash[:notice] = 'Welcome back, ' + aUser.name
    session[:username] = aUser.name  
    session[:login_time] = Time.now.to_i     
    Rails.cache.clear
    redirect_to :action => 'index'  
  end    

  def login_json
    aUser = User.find_by_name('walker')  

    logger.error("VC: Logging in as  " + aUser.name)
    flash[:notice] = 'Welcome back, ' + aUser.name
    session[:username] = aUser.name  
    session[:login_time] = Time.now.to_i     
    Rails.cache.clear
    render :json => { 'username' => aUser.name }  
  end    
  
  def verify_browserid
    if (params[:assertion])                     
      # now post to https://browserid.org/verify with two POST args, assertion and audience
      
      url = URI.parse('https://browserid.org/verify')                       
      http = Net::HTTP.new(url.host, url.port)

      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({'assertion' => params[:assertion], 'audience' => request.host})
      res = http.start {|http| http.request(req) } 
                                                                
      # could be {"status":"failure","reason":"audience mismatch: domain mismatch"}
      # results should be JSON like result {"status":"okay","email":"walker@shout.net","audience":"localhost:3000","valid-until":1313649622973,"issuer":"browserid.org:443"}

      parsedResults = ActiveSupport::JSON.decode(res.body())  

      if (parsedResults["status"] == "okay" and parsedResults["email"] == "walker@shout.net")
        logger.error("VC: Logging in as " + parsedResults["email"])
        flash[:notice] = 'Welcome back, ' + parsedResults["email"]
        session[:username] = parsedResults["email"] 
        session[:login_time] = Time.now.to_i     
        Rails.cache.clear   
        render :text => '', :layout => false, :status => 200    
      elsif (parsedResults["email"])
        logger.error("VC: no editing priviledges for " + parsedResults["email"])
        flash[:error] = 'No editing priviledges for ' + parsedResults["email"]
        session[:username] = nil    
        session[:login_time] = nil 
        render :text => '', :layout => false, :status => 500
      elsif (parsedResults["status"] == "failure")
        flash[:error] = 'Cannot log in, ' + parsedResults["reason"]
        logger.error('Cannot log in, ' + parsedResults["reason"])
      end
    else
      logger.error("VC: Failed login attempt")
      flash[:error] = 'Incorrect login or password; please try again'
      session[:username] = nil    
      session[:login_time] = nil 
      render :text => '', :layout => false, :status => 500
    end
  end
    
  def search
    @page_title = "search results"
    if (params[:terms] != nil && params[:terms].length > 0) then
      @found_counties = County.find(:all, :conditions => ["name like ?", "%#{params[:terms]}%"], :order => "id")
      @found_taxons = Taxon.find_by_sql(["SELECT DISTINCT taxons.* FROM taxons, sightings WHERE sightings.taxon_latin_name=taxons.latin_name AND (taxons.common_name LIKE ? or taxons.latin_name LIKE ?) ORDER BY taxons.sort", "%#{params[:terms]}%", "%#{params[:terms]}%"])

      #for trips, look in both the trip names and the notes, removing duplicates
      @found_trips = Trip.find(:all, :conditions => ["name like ?", "%#{params[:terms]}%"], :order => "id") | Trip.find(:all, :conditions => ["notes like ?", "%#{params[:terms]}%"], :order => "id")

      @found_locations = Location.find(:all, :conditions => ["name like ?", "%#{params[:terms]}%"], :order => "id")
      @terms = params[:terms]

      if ((@found_taxons.size + @found_counties.size + @found_trips.size + @found_locations.size) == 1) then    
  	    if (@found_taxons.size == 1) then
            redirect_to :controller => 'taxons', :action => 'show', :id => @found_taxons[0]       
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

  def logout_json
    if (session[:username] != nil) then
      logger.error("VC: Logging out")
      flash[:notice] = 'Logged out'
      Rails.cache.clear
      session[:username] = nil    
      session[:login_time] = nil
    end
    
    render :json => { 'username' => nil }  
  end

end
