module TaxonsHelper
	
	def show_taxon_list(taxon_list, headings_flag)
	    sorted_taxon_list = Taxon.sort_taxonomic(taxon_list)
    
		if taxon_list.size > 40
			render :partial => 'taxons/divided_list', :object => sorted_taxon_list, :locals => { :show_headings => headings_flag }
		else
			render :partial => 'taxons/undivided_list', :object => sorted_taxon_list, :locals => { :show_headings => headings_flag }
		end
	end

	def taxon_latin_name_path taxon
	    '/taxons/latin/%s' % taxon.latin_name.gsub(' ', '_')
	end	

	def taxon_anchor_name taxon
		taxon.latin_name.gsub(' ', '_')
	end

	def taxon_family_name_path family_name
	    '/families/%s' % family_name.gsub(' ', '_')
	end	

	# NOTE: assume all family_name values look like 'Anatidae (Ducks, Geese, and Waterfowl)'
	def get_family_common_name combined_family_name
		return combined_family_name.split(/[()]/)[1]
	end

	# NOTE: assume all family_name values look like 'Anatidae (Ducks, Geese, and Waterfowl)'
	def get_family_latin_name combined_family_name
		return combined_family_name.split(/[()]/)[0]
	end
end
