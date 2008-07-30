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
    yield if subject.reference_url && subject.reference_url.length > 1
  end
  
  def has_notes?(subject, &block)
    yield if subject.notes && subject.notes.length > 1
  end

  def has_no_notes?(subject, &block)
    yield if ! subject.notes || subject.notes.length == 0
  end

  def has_sightings?(subject, &block)
    yield if subject.sightings && subject.sightings.length > 1
  end
                      
  def has_columns?(&block)
    yield if not (@controller.send(:iphone?))
  end

  def open_first_column
    "<table width=\"100%\" cellpadding=\"0px\" cellspacing=\"0px\"><tr valign=\"top\"><td valign=\"top\" width=\"50%\">" if not (iphone?)
  end         
  
  def between_columns
		"</td><td valign=\"top\" width=\"50%\">" if not (iphone?)
	end

  def close_second_column
		"</td></tr></table>" if not (iphone?)
	end	
  
  def editing_is_allowed?(&block)
    yield if session[:username] != nil
  end
  
  def is_laptop
    `hostname`.strip == "vermillion.local"
  end
end
