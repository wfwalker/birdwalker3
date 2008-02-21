require File.dirname(__FILE__) + '/../test_helper'

class SpeciesTest < Test::Unit::TestCase
  fixtures :species

  # Replace this with your real tests.
  def test_fixtures
    assert Species.count == 2
  end
end
