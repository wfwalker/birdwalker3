module SpeciesHelper
  def show_species_list(species_list, headings_flag)
    sorted_species_list = Species.sort_taxonomic(species_list)
    
	  if species_list.size > 40
			render :partial => 'species/divided_list', :object => sorted_species_list, :locals => { :show_headings => headings_flag }
		else
		  render :partial => 'species/undivided_list', :object => sorted_species_list, :locals => { :show_headings => headings_flag }
		end
	end
end
