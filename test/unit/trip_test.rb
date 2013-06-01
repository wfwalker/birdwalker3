require File.dirname(__FILE__) + '/../test_helper'

class TripTest < ActiveSupport::TestCase
  fixtures :locations
  fixtures :trips
  fixtures :photos
  fixtures :sightings
  
  def setup
    @first = trips(:trip_one)
  end

  def test_sightings
    assert_equal 2, @first.sightings.count, "test fixture has two sightings for this trip"
  end

  def test_taxons
    assert_equal 2, @first.taxons.count, "test fixture has two taxons for this trip"
  end

  def test_locations
    assert_equal 2, @first.locations.count, "test fixture has two locations for this trip"
  end

  def test_photos
    assert_equal 2, @first.photos.count, "test fixture has two photos for this trip"
  end
end
