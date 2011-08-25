class CreateFamilies < ActiveRecord::Migration
  def self.up
    create_table :families do |t|
      t.text    "latin_name"
      t.text    "common_name"
      t.integer "taxonomic_sort_id"
    end

    add_index "families", ["taxonomic_sort_id"], :name => "TaxonomicSortIndex"
  end

  def self.down
    drop_table :families
  end
end
