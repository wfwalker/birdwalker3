class CreateSpecies < ActiveRecord::Migration
  def self.up
    create_table :species do |t|
      t.string  "abbreviation",  :limit => 6
      t.text    "latin_name"
      t.text    "common_name"
      t.text    "notes"
      t.text    "reference_url"
      t.boolean "aba_countable",              :default => true, :null => false
      t.integer "family_id"
    end

    add_index "species", ["aba_countable"], :name => "aba_countableIndex"
    add_index "species", ["abbreviation"], :name => "AbbreviationIndex"
  end

  def self.down
    drop_table :species
  end
end
