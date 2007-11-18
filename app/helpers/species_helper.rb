module SpeciesHelper
  def show_species_list(species_list)
	  if species_list.size > 40
			render :partial => 'species/divided_list', :object => species_list
		else
		  render :partial => 'species/undivided_list', :object => species_list
		end
	end
end
