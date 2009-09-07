class Emailer < ActionMailer::Base           
  helper :trips     
  helper :application
  
  def newsletter(recipient, recent_trips, sent_at = Time.now)    
    @subject = "Latest Newsletter"        
    @recent_trips = recent_trips
    @recipients = recipient
    @from = 'no-reply@yourdomain.com'
    @sent_on = sent_at
    @body["title"] = 'Latest Newsletter'
    @body["email"] = 'sender@yourdomain.com'
    @headers = {}        
    @content_type = "text/html"    
    default_url_options[:host] = 'birdwalker.com'
  end  
end
