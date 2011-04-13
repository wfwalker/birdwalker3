# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  # session :session_key => '_HelloWorld_session_id'
  
  layout :choose_layout

  before_filter :check_uri
  
  def check_uri
    redirect_to request.protocol + "birdwalker.com" + request.request_uri if /spflrc/.match(request.host)
  end

  protected

  def iphone?
    ENV['force_iphone'] == 'true' ||
      (request.class && request.class.to_s.include?("CgiRequest") && request.user_agent && request.user_agent.include?('iPhone'))
  end
  
  def choose_layout  
    if iphone?  
        "iphone"  
      else
        "standard"
    end  
  end    
  
  def inactivity_timeout
    if (ENV['inactivity_timeout'] != nil)
      ENV['inactivity_timeout']
    else
      1200
    end
  end         
  
  def update_activity_timer
    if (session[:login_time] != nil) then
      logger.error("Activtely logged in, setting activity timer")
      session[:login_time] = Time.now.to_i    
    else
      logger.error("Not logged in, no timeout check")
    end
  end
  
  def verify_credentials
    if (session[:username] == nil) then
      # username is nil, just clobber login_time
      logger.error("Not logged in, no timeout check")
      session[:login_time] = nil      
      redirect_to :controller => 'bird_walker', :action => 'login'
    else
      if (session[:login_time] == nil) then
        # username is not nil but login_time is nil, this should never happen!
        flash[:error] = 'Editing session timed out; please login again to continue editing'
        session[:username] = nil    
        session[:login_time] = nil
        redirect_to :controller => 'bird_walker', :action => 'login'  
      else
        # username is valid, login_time is valid, do the real checking
        inactivity = Time.now.to_i - session[:login_time]
        logger.error("Checking timeout " + inactivity.to_s + " versus " + inactivity_timeout.to_s)

        if (inactivity > inactivity_timeout) then
          # timeout! clobber the session
          flash[:error] = 'Editing session timed out; please login again to continue editing'
          session[:username] = nil    
          session[:login_time] = nil
          redirect_to :controller => 'bird_walker', :action => 'login'  
        else
          # active session, update the timer
          logger.error("Activtely logged in, setting activity timer")
          session[:login_time] = Time.now.to_i
        end
      end
    end
  end
end
