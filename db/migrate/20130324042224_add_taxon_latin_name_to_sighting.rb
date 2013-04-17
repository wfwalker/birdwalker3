class AddTaxonLatinNameToSighting < ActiveRecord::Migration
  def change
    add_column :sightings, :taxon_latin_name, :string
	add_index :sightings, :taxon_latin_name
  end
end
