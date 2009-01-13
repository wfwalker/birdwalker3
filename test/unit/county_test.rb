require File.dirname(__FILE__) + '/../test_helper'

class CountyTest < Test::Unit::TestCase
  fixtures :sightings, :locations, :counties, :states, :species, :trips

  def test_trips_per_year
    assert_equal 1, County.find(1).year_span
    assert_equal 2, County.find(1).trips.size
    assert_equal 2, County.find(1).trips_per_year
  end
end
