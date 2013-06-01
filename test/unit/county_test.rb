require File.dirname(__FILE__) + '/../test_helper'

class CountyTest < ActiveSupport::TestCase
  fixtures :photos, :locations, :taxons, :trips, :sightings, :counties, :states

  def setup
    @county_one = counties(:county_one)
  end

  def test_trips_per_year
    assert_equal 1, @county_one.year_span
    assert_equal 2, @county_one.trips.size
    assert_equal 2, @county_one.trips_per_year
  end
  
  def test_sightings
    assert_equal 2, @county_one.sightings.count, "test fixture has two sightings for this county"
  end

  def test_taxons
    assert_equal 1, @county_one.taxons.count, "test fixture has one taxon for this county"
  end

  def test_locations
    assert_equal 1, @county_one.locations.count, "test fixture has one location for this county"
  end

  def test_trips
    assert_equal 2, @county_one.trips.count, "test fixture has two trips for this county"
  end

  def test_photos
    assert_equal 1, @county_one.photos.count, "test fixture has one photo for this county"
  end
end
