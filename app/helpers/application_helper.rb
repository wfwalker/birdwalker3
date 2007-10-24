# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def nice_date(date)
    h date.strftime("%A, %B %d, %Y")
  end
  
  def short_nice_date(date)
    h date.strftime("%B %d, %Y")
  end
  
  def month_day(date)
    h date.strftime("%B %d")
  end
  
  def sighting_year_range()
    (1996..2007)
  end
  
  def has_reference_url?(subject, &block)
    yield if subject.reference_url && subject.reference_url.length > 1
  end
  
  def has_notes?(subject, &block)
    yield if subject.notes && subject.notes.length > 1
  end
end
