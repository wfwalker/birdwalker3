require File.dirname(__FILE__) + '/../test_helper'

class SpeciesTest < Test::Unit::TestCase
  fixtures :species, :families, :photos

  # Replace this with your real tests.
  def test_fixtures
    assert Species.count == 2
  end                 
  
  def test_find_all_photographed_not_excluded
    assert Species.find_all_photographed_not_excluded.size == 2
  end
end
