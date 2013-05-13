module PhotosHelper
  def safe_nice_trip_date(photo)
	  if (photo.trip) then
		  nice_date(photo.trip.date)
	  else
			"unknown"
	  end
  end

  def safe_location_name(photo)
	  if (photo && photo.location) then
		  photo.location.name
	  else
			"unknown"
	  end
  end

  def safe_trip_name(photo)
	  if (photo && photo.trip) then
		  photo.trip.name
	  else
			"unknown"
	  end
  end

  def safe_species_common_name(photo)
	  if (photo && photo.taxon) then
		  photo.taxon.common_name
	  else
			"unknown"
	  end
  end
  	
	def show_taxonomic_photo_list(photo_list)
	  sorted_photo_list = Sighting.sort_taxonomic(photo_list)
	      
    if sorted_photo_list.size > 40
			render :partial => 'photos/divided_list', :object => sorted_photo_list
		else
		  render :partial => 'photos/undivided_list', :object => sorted_photo_list
		end
	end

	def show_chronological_photo_list(photo_list)
	  sorted_photo_list = Sighting.sort_chronological(photo_list);
	      
	  render :partial => 'photos/chronological_list', :object => sorted_photo_list
	end
	
	def gallery_page_size()
	  10
  end
end
