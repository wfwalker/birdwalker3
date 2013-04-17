class CreateTaxons < ActiveRecord::Migration
  def change
    create_table :taxons do |t|
      t.integer :sort
      t.string :category
      t.string :latin_name
      t.string :common_name
      t.string :abbreviation
      t.string :range
      t.string :order
      t.string :family

      t.timestamps
    end

    add_index "taxons", ["latin_name"], :name => "LatinNameIndex"
    add_index "taxons", ["abbreviation"], :name => "AbbreviationIndex"
  end
end
