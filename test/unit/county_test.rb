require File.dirname(__FILE__) + '/../test_helper'

class CountyTest < ActiveSupport::TestCase
  fixtures :photos, :locations, :taxons, :trips, :sightings, :counties, :states

  def setup
    @first_id = counties(:county_one).id
  end

  def test_trips_per_year
    assert_equal 1, County.find(@first_id).year_span
    assert_equal 2, County.find(@first_id).trips.size
    assert_equal 2, County.find(@first_id).trips_per_year
  end
  
  def test_sightings
    assert_equal 2, County.find(@first_id).sightings.count, "test fixture has two sightings for this county"
  end

  def test_taxons
    assert_equal 1, County.find(@first_id).taxons.count, "test fixture has one taxon for this county"
  end

  def test_locations
    assert_equal 1, County.find(@first_id).locations.count, "test fixture has one location for this county"
  end

  def test_trips
    assert_equal 2, County.find(@first_id).trips.count, "test fixture has two trips for this county"
  end

  def test_photos
    assert_equal 1, County.find(@first_id).photos.count, "test fixture has one photo for this county"
  end
end
