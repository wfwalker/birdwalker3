module LocationsHelper
  def has_only_one_location?(locationcontainer, &block)
    yield if locationcontainer.locations.size == 1
  end
  
  def safe_county_name(location)
	  if (location.county && location.county.size > 0) then
		  location.county
	  else
			"Unknown"
	  end
  end
  
  def show_location_list(locationcontainer)
    return unless locationcontainer.locations.size > 1
    
	  if locationcontainer.locations.size > 30
			render :partial => 'locations/condensed_list', :object => locationcontainer
		else
		  render :partial => 'locations/full_list', :object => locationcontainer
		end
	end
end
