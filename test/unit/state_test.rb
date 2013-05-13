require File.dirname(__FILE__) + '/../test_helper'

class StateTest < ActiveSupport::TestCase
  fixtures :photos, :locations, :species, :trips, :sightings, :counties, :states

  def setup
    @first_id = states(:state_one).id
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_sightings
    assert_equal 2, State.find(@first_id).sightings.count, "test fixture has two sightings for this State"
  end

  def test_taxon
    assert_equal 1, State.find(@first_id).taxons.count, "test fixture has one taxon for this State"
  end

  def test_locations
    assert_equal 1, State.find(@first_id).locations.count, "test fixture has one location for this State"
  end

  def test_counties
    assert_equal 1, State.find(@first_id).counties.count, "test fixture has one county for this State"
  end

  def test_trips
    assert_equal 2, State.find(@first_id).trips.count, "test fixture has two trips for this State"
  end

  def test_photos
    assert_equal 1, State.find(@first_id).photos.count, "test fixture has one photo for this State"
  end
end
