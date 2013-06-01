require 'test_helper'

class TaxonTest < ActiveSupport::TestCase
  fixtures :taxons

  test "should find by id" do
  	assert_not_nil taxons(:taxon_one)
  end

  test "should find by abbreviation" do
  	assert_not_nil Taxon.find_by_abbreviation('ivbwoo')
  end

  test "should find by latin_name" do
  	assert_not_nil Taxon.find_by_latin_name('Latinus latinae')
  end

end
