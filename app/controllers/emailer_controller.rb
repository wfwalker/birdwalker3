class EmailerController < ApplicationController     
  def sendmail                     
    email = params["email"]
    recipient = email["recipient"]
    
    Emailer.deliver_newsletter(recipient, Trip.find(:all, :limit => 8, :order => 'date DESC'))
    
    return if request.xhr?
    render :text => 'Message sent successfully'
  end    
  
  def index
    render :file => 'app/views/emailer/index.rhtml'
  end
end
