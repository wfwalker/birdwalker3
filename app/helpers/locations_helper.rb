module LocationsHelper
  def has_only_one_location?(locationcontainer, &block)
    yield if locationcontainer.locations.size == 1
  end

  def has_multiple_locations?(locationcontainer, &block)
    yield if locationcontainer.locations.size > 1
  end

  def show_location_list(location_list, headings_flag)
	  if location_list.size > 30
			render :partial => 'locations/divided_list', :object => location_list, :locals => { :show_headings => headings_flag }
		else
		  render :partial => 'locations/undivided_list', :object => location_list, :locals => { :show_headings => headings_flag }
		end
	end
end
