module LocationsHelper
  def has_only_one_location?(locationcontainer, &block)
    yield if locationcontainer.locations.size == 1
  end

  def has_multiple_locations?(locationcontainer, &block)
    yield if locationcontainer.locations.size > 1
  end

  def show_location_list(locationcontainer)
    return unless locationcontainer.locations.size > 1
    
	  if locationcontainer.locations.size > 30
			render :partial => 'locations/divided_list', :object => locationcontainer
		else
		  render :partial => 'locations/undivided_list', :object => locationcontainer
		end
	end
end
