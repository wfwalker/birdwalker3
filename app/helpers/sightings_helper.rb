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

  def safe_species_common_name(sighting)
	  if (sighting.species) then
		  sighting.species.common_name
	  else
			"unknown"
	  end
  end
end
