module SightingsHelper
  def safe_nice_trip_date(sighting)
	  if (sighting.trip) then
		  nice_date(sighting.trip.date)
	  else
			"unknown"
	  end
  end

  def safe_location_name(sighting)
	  if (sighting.location) then
		  sighting.location.name
	  else
			"unknown"
	  end
  end

  def safe_trip_name(sighting)
	  if (sighting.trip) then
		  sighting.trip.name
	  else
			"unknown"
	  end
  end

  def safe_species_common_name(sighting)
	  if (sighting.species) then
		  sighting.species.common_name
	  else
			"unknown"
	  end
  end
  
  def show_thumbnail_list(sighting_list)
	  if sighting_list.size > 0
			render :partial => 'sightings/thumbnail_list', :object => sighting_list
		end
	end
	
	def show_taxonomic_sighting_list(sighting_list)
	  sorted_sighting_list = Sighting.sort_taxonomic(sighting_list)
	      
    if sorted_sighting_list.size > 40
			render :partial => 'sightings/divided_list', :object => sorted_sighting_list
		else
		  render :partial => 'sightings/undivided_list', :object => sorted_sighting_list
		end
	end

	def show_chronological_sighting_list(sighting_list)
	  sorted_sighting_list = Sighting.sort_chronological(sighting_list);
	      
	  render :partial => 'sightings/undivided_list', :object => sorted_sighting_list
	end
end
