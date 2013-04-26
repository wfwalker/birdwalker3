module TaxonsHelper

	def taxon_latin_name_path taxon
	    '/taxons/latin/%s' % taxon.latin_name.sub(' ', '_')
	end	

end
