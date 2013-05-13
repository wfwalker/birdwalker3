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
	    '/taxons/latin/%s' % taxon.latin_name.sub(' ', '_')
	end	

	def taxon_anchor_name taxon
		taxon.latin_name.sub(' ', '_')
	end
end
