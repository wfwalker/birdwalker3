module SpeciesHelper
  def show_species_list(speciescontainer)
	  if speciescontainer.species.size > 50
			render :partial => 'species/divided_list', :object => speciescontainer
		else
		  render :partial => 'species/undivided_list', :object => speciescontainer
		end
	end
end
