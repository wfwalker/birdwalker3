module CountiesHelper
  def show_county_list(county_list, headings_flag)
	  if county_list.size > 30
			render :partial => 'counties/divided_list', :object => county_list, :locals => { :show_headings => headings_flag }
		else
		  render :partial => 'counties/undivided_list', :object => county_list, :locals => { :show_headings => headings_flag }
		end
	end
end
