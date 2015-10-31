# TODO:
# update taxons,sightings set taxons.lifebird=1 where sightings.taxon_latin_name=taxons.latin_name and sightings.exclude=0;  

class AddLifebirdToTaxon < ActiveRecord::Migration
  def change
    add_column :taxons, :lifebird, :boolean
  end
end
