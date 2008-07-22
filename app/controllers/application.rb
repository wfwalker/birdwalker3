# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_HelloWorld_session_id'
  
  layout :choose_layout
  
  def iphone?                   
    request.class.to_s.include?("CgiRequest") && request.user_agent.include?('iPhone')  
    #true
  end  
  
  def choose_layout  
    if iphone?  
        "iphone"  
      else
        "standard"
    end  
  end    
  
  def is_editing_allowed?()
    session[:username] != nil
  end

end
