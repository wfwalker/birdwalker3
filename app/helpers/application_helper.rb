# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def nice_date(date)
    h date.strftime("%A, %B %d, %Y")
  end
  
  def short_nice_date(date)
    h date.strftime("%b %d, %Y")
  end
  
  def month_day(date)
    h date.strftime("%B %d")
  end
  
  def sighting_year_range()
    (1996..2008)
  end
  
  def has_reference_url?(subject, &block)
    yield if subject.reference_url && subject.reference_url.length >= 1
  end
  
  def has_notes?(subject, &block)
    yield if subject.notes && subject.notes.length >= 1
  end

  def has_no_notes?(subject, &block)
    yield if ! subject.notes || subject.notes.length == 0
  end

  def has_sightings?(subject, &block)
    yield if subject.sightings && subject.sightings.length >= 1
  end         
  
  def iphone?
    @controller.send(:iphone?)    
  end
                      
  def has_columns?(&block)         
    yield unless iphone?
  end

  def has_no_columns?(&block)
    yield if iphone?
  end

  def open_first_column
    "<table width=\"100%\" cellpadding=\"0px\" cellspacing=\"0px\"><tr valign=\"top\"><td valign=\"top\" width=\"50%\">" unless iphone?
  end         
  
  def between_columns
		"</td><td valign=\"top\" width=\"50%\">" unless iphone?
	end

  def close_second_column
		"</td></tr></table>" unless iphone?
	end	                        
	
	def counts_by_month_image_tag(totals, width=370, height=150) 
	  monthly_max = 10 * (totals[1..12].max / 10.0).ceil
	  
	  stuff = {
	    :chco => 555555,
	    :chxt => "y",       
	    :chxr => "0,0," + monthly_max.to_s,
	    :cht => "bvs",
	    :chd => "t:" + totals[1..12].join(","),
	    :chds => "0," + monthly_max.to_s,
	    :chs => width.to_s + "x" + height.to_s,
	    :chl => Date::ABBR_MONTHNAMES[1..12].join("|")
	  } 
	      
    chartString = "http://chart.apis.google.com/chart" + "?" + stuff.collect { |x| x[0].to_s + "=" + x[1].to_s }.join("&")
    "<img src=\"" + chartString + "\" alt=\"Totals By Month\" width=\"" + width.to_s + "\" height=\"" + height.to_s + "\"/>"	                                     
  end

	def counts_by_year_image_tag(totals, width=370, height=150) 
	  yearly_max = 10 * (totals[1996..2008].max / 10.0).ceil
	  
	  stuff = {
	    :chco => 555555,
	    :chxt => "y",       
	    :chxr => "0,0," + yearly_max.to_s,
	    :cht => "bvs",
	    :chd => "t:" + totals[1996..2008].join(","),
	    :chds => "0," + yearly_max.to_s,
	    :chs => width.to_s + "x" + height.to_s,
	    :chl => (1996..2008).to_a.join("|")
	  } 
	      
    chartString = "http://chart.apis.google.com/chart" + "?" + stuff.collect { |x| x[0].to_s + "=" + x[1].to_s }.join("&")
    "<img src=\"" + chartString + "\" alt=\"Totals By Year\" width=\"" + width.to_s + "\" height=\"" + height.to_s + "\"/>"	                                     
  end
  
  def inactivity_timeout
    if (ENV['inactivity_timeout'] != nil)
      ENV['inactivity_timeout']
    else
      600
    end
  end      
  
  def check_for_timeout
    if (session[:username] == nil) then
      # username is nil, just clobber login_time
      logger.error("Not logged in, no timeout check")
      session[:login_time] = nil      
    else
      if (session[:login_time] == nil) then
        # username is not nil but login_time is nil, this should never happen!
        flash[:error] = 'Editing session timed out; please login again to continue editing'
        session[:username] = nil    
        session[:login_time] = nil
      else
        # username is valid, login_time is valid, do the real checking
        inactivity = Time.now.to_i - session[:login_time]
        logger.error("Checking timeout " + inactivity.to_s + " versus " + inactivity_timeout.to_s)

        if (inactivity > inactivity_timeout) then
          # timeout! clobber the session
          flash[:error] = 'Editing session timed out; please login again to continue editing'
          session[:username] = nil    
          session[:login_time] = nil
        else
          # active session, update the timer
          logger.error("Activtely logged in, setting activity timer")
          session[:login_time] = Time.now.to_i
        end
      end
    end
  end
  
  def editing_is_allowed?(&block)
    yield if session[:username] != nil
  end
  
  def is_laptop
    `hostname`.strip == "vermillion.local"
  end
end
