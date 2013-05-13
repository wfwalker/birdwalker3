module SightingsHelper
  def safe_nice_trip_date(sighting)
	  if (sighting.trip) then
		  nice_date(sighting.trip.date)
	  else
			"unknown"
	  end
  end
                        
  def has_count?(subject, &block)
    yield if subject.count
  end

  def safe_location_name(sighting)
	  if (sighting && sighting.location) then
		  sighting.location.name
	  else
			"unknown"
	  end
  end

  def safe_trip_name(sighting)
	  if (sighting && sighting.trip) then
		  sighting.trip.name
	  else
			"unknown"
	  end
  end

  def safe_trip_date(sighting)
	  if (sighting && sighting.trip) then
		  short_nice_date(sighting.trip.date)
	  else
			"unknown"
	  end
  end

  # used only by Species.life_list
	def show_chronological_sighting_list(sighting_list)
	  sorted_sighting_list = Sighting.sort_chronological(sighting_list);
	      
	  render :partial => 'sightings/chronological_list', :object => sorted_sighting_list
	end
end
