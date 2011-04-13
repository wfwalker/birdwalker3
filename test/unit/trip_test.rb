require File.dirname(__FILE__) + '/../test_helper'

class TripTest < ActiveSupport::TestCase
  fixtures :photos, :locations, :species, :trips, :sightings
  
  def setup
    @first_id = trips(:trip_one).id
  end

  def test_sightings
    assert_equal 2, Trip.find(@first_id).sightings.size, "test fixture has two sightings for this trip"
  end

  def test_species
    assert_equal 2, Trip.find(@first_id).species.size, "test fixture has two species for this trip"
  end

  def test_locations
    assert_equal 2, Trip.find(@first_id).locations.size, "test fixture has two locations for this trip"
  end

  def test_photos
    assert_equal 2, Trip.find(@first_id).photos.size, "test fixture has two photos for this trip"
  end
end
