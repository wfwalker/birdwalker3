require File.dirname(__FILE__) + '/../test_helper'

class SightingTest < ActiveSupport::TestCase
  fixtures :sightings, :trips, :locations, :species, :counties, :states, :families

  def test_properties
    assert_equal 4, Sighting.find(:all).length
    
    assert_equal true, Sighting.find_by_id(1).heard_only
    assert_equal false, Sighting.find_by_id(2).heard_only
    assert_equal false, Sighting.find_by_id(3).heard_only
    assert_equal false, Sighting.find_by_id(4).heard_only
  end

  def test_direct_associations
    assert_equal 2, Location.find(1).sightings.length
    assert_equal 2, Location.find(2).sightings.length

    assert_equal 2, Trip.find(1).sightings.length
    assert_equal 2, Trip.find(2).sightings.length

    assert_equal 2, Species.find(1).sightings.length
    assert_equal 2, Species.find(2).sightings.length

    assert_equal 1, County.find(1).locations.length
    assert_equal 1, County.find(2).locations.length
  end
  
  def test_secondary_associations
    # species to/from locations
    assert_equal 1, Location.find(1).species.length
    assert_equal 1, Location.find(2).species.length

    assert_equal 1, Species.find(1).locations.length
    assert_equal 1, Species.find(2).locations.length

    # trips to/from species
    assert_equal 2, Trip.find(1).species.length
    assert_equal 2, Trip.find(2).species.length

    assert_equal 2, Species.find(1).trips.length
    assert_equal 2, Species.find(2).trips.length

    # trips to/from location
    assert_equal 2, Trip.find(1).locations.length
    assert_equal 2, Trip.find(2).locations.length

    assert_equal 2, Location.find(1).trips.length
    assert_equal 2, Location.find(2).trips.length
  end
  
  def test_remote_associations
    assert_equal 2, County.find(1).trips.length
    assert_equal 2, County.find(2).trips.length

    assert_equal 1, County.find(1).species.length
    assert_equal 1, County.find(2).species.length

    assert_equal 2, State.find(1).trips.length
    assert_equal 2, State.find(2).trips.length

    assert_equal 2, State.find(1).species.length
    assert_equal 2, State.find(2).species.length

    assert_equal 1, State.find(1).locations.length
    assert_equal 1, State.find(2).locations.length
  end
end
