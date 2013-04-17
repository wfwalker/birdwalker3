require 'test_helper'

class TaxonTest < ActiveSupport::TestCase
  fixtures :taxons

  test "should find by id" do
  	assert_not_nil Taxon.find(1)
  end

  test "should find by abbreviation" do
  	assert_not_nil Taxon.find_by_abbreviation('ivbwoo')
  end
end
