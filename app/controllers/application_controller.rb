# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  # session :session_key => '_HelloWorld_session_id'
  
  layout :choose_layout

  before_filter :check_uri

  helper_method :page_kind

  def page_kind
    raise "subclass should implement"
  end
  
  def check_uri
    redirect_to request.protocol + "birdwalker.com" + request.request_uri if /spflrc/.match(request.host)
  end

  protected

  def choose_layout  
    "responsive"
  end    
  
  def inactivity_timeout
    if (ENV['inactivity_timeout'] != nil)
      ENV['inactivity_timeout'].to_i
    else
      1200
    end
  end         
  
  def has_valid_credentials
    return ((session[:login_time] != nil) and (session[:username] != nil))
  end
    
  def update_activity_timer
    if (ENV['force_loggedin']) then
        logger.error("VC: forcing login, setting activity timer")
        session[:login_time] = Time.now.to_i
        session[:username] = 'forced'
    end

    if (has_valid_credentials) then
      # username is valid, login_time is valid, do the real checking
      inactivity = Time.now.to_i - session[:login_time]
      logger.error("VC: Checking timeout " + inactivity.to_s + " versus " + inactivity_timeout.to_s)

      if (inactivity > inactivity_timeout) then
        logger.error("VC: timed out, removing credentials")
        # timeout! clobber the session
        flash[:error] = 'Editing session timed out; please login again to continue editing'
        session[:username] = nil    
        session[:login_time] = nil
      else
        # active session, update the timer
        logger.error("VC: Actively logged in, setting activity timer")
        session[:login_time] = Time.now.to_i
      end
    else
      logger.error("VC: Not logged in, no timeout check")
    end
  end
  
  def verify_credentials
    if (ENV['force_loggedin']) then
      logger.error("VC: forcing login, setting activity timer")
      session[:login_time] = Time.now.to_i
      session[:username] = 'forced'
      return;
    end
      
    if (session[:username] == nil) then
      # username is nil, just clobber login_time
      logger.error("VC: Not logged in, redirecting to index")
      session[:login_time] = nil      
      #TODO: something smarter than just index page?
      redirect_to :controller => 'bird_walker', :action => 'index'
    else
      if (session[:login_time] == nil) then
        # username is not nil but login_time is nil, this should never happen!
        logger.error("VC: timed out, removing credentials and redirecting")
        flash[:error] = 'Editing session timed out; please login again to continue editing'
        session[:username] = nil    
        session[:login_time] = nil
        #TODO: something smarter than just index page?
        redirect_to :controller => 'bird_walker', :action => 'index'  
      else
        # username is valid, login_time is valid, do the real checking
        inactivity = Time.now.to_i - session[:login_time]
        logger.error("VC: Checking timeout " + inactivity.to_s + " versus " + inactivity_timeout.to_s)

        if (inactivity > inactivity_timeout) then
          # timeout! clobber the session
          logger.error("VC: timed out, removing credentials and redirecting")
          flash[:error] = 'Editing session timed out; please login again to continue editing'
          session[:username] = nil    
          session[:login_time] = nil
          #TODO: something smarter than just index page?
          redirect_to :controller => 'bird_walker', :action => 'index'  
        else
          # active session, update the timer
          logger.error("VC: Actively logged in, setting activity timer")
          session[:login_time] = Time.now.to_i
        end
      end
    end
  end
end
