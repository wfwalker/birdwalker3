module SpeciesHelper
  def show_species_list(species_list)
    sorted_species_list = Species.sort_taxonomic(species_list)
    
	  if species_list.size > 40
			render :partial => 'species/divided_list', :object => sorted_species_list
		else
		  render :partial => 'species/undivided_list', :object => sorted_species_list
		end
	end
end
