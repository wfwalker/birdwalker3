module TripsHelper
  def has_only_one_trip?(tripcontainer, &block)
    yield if tripcontainer.trips.size == 1
  end

  def has_photo?(trip, &block)
    yield if trip.sightings_with_photos.size > 1
  end
    
  def show_trip_list(tripcontainer)
	  if tripcontainer.trips.size > 50
			render :partial => 'trips/divided_list', :object => tripcontainer
		else
		  render :partial => 'trips/undivided_list', :object => tripcontainer
		end
	end
end
