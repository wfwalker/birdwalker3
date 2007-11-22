module SpeciesHelper
  def show_species_list(species_list)
    
	  if species_list.size > 40
			render :partial => 'species/divided_list', :object => species_list
		else
      sorted_species_list = species_list.sort_by { |s| s.family.taxonomic_sort_id * 100000000000 + s.id }
		  render :partial => 'species/undivided_list', :object => sorted_species_list
		end
	end
end
