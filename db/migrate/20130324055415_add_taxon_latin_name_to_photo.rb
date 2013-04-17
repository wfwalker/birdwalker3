class AddTaxonLatinNameToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :taxon_latin_name, :string
	add_index :photos, :taxon_latin_name
  end
end
