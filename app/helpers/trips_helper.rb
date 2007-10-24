module TripsHelper
  def has_only_one_trip?(tripcontainer, &block)
    yield if tripcontainer.trips.size == 1
  end
    
  def show_trip_list(tripcontainer)
    return unless tripcontainer.trips.size > 1
    
	  if tripcontainer.trips.size > 30
			render :partial => 'trips/condensed_list', :object => tripcontainer
		else
		  render :partial => 'trips/full_list', :object => tripcontainer
		end
	end
end
