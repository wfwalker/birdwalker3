module TripsHelper
  def has_only_one_trip?(tripcontainer, &block)
    yield if tripcontainer.trips.size == 1
  end

  def has_photo?(trip, &block)
    yield if trip.sightings_with_photos.size > 1
  end
    
  def show_trip_list(triplist)
	  if triplist.size > 50
			render :partial => 'trips/divided_list', :object => triplist
		else
		  render :partial => 'trips/undivided_list', :object => triplist
		end
	end
end
