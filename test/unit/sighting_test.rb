require File.dirname(__FILE__) + '/../test_helper'

class SightingTest < ActiveSupport::TestCase
  fixtures :countries
  fixtures :states
  fixtures :counties
  fixtures :locations
  fixtures :trips
  fixtures :taxons
  fixtures :sightings

  def test_properties
    assert_equal 4, Sighting.find(:all).length
    
    assert_equal true, sightings(:sighting_one).heard_only
    assert_equal false, sightings(:sighting_two).heard_only
    assert_equal false, sightings(:sighting_three).heard_only
    assert_equal false, sightings(:sighting_four).heard_only
  end

  def test_sighting_location
    assert_equal locations(:location_one).id, sightings(:sighting_one).location_id, "sighting_one was at location_one"
  end

  def test_sighting_trip
    assert_equal trips(:trip_one).id, sightings(:sighting_one).trip_id, "sighting_one was on trip_one"
  end

  def test_location_sightings
    assert_equal 2, locations(:location_one).sightings.length, "location_one has two sightings"
    assert_equal 2, locations(:location_two).sightings.length, "location_two has two sightings"
  end

  def test_trip_sightings
    assert_equal 2, trips(:trip_one).sightings.length
    assert_equal 2, trips(:trip_two).sightings.length
  end

  def test_taxon_sightings
    assert_equal 2, taxons(:taxon_one).sightings.length
    assert_equal 2, taxons(:taxon_two).sightings.length
  end

  def test_county_locations
    assert_equal 1, counties(:county_one).locations.length
    assert_equal 1, counties(:county_two).locations.length
  end
  
  def test_location_taxons
    # species to/from locations
    assert_equal 1, locations(:location_one).taxons.length
    assert_equal 1, locations(:location_two).taxons.length
  end

  def test_taxon_locations
    assert_equal 1, taxons(:taxon_one).locations.length
    assert_equal 1, taxons(:taxon_two).locations.length
  end

  def test_trip_taxons
    # trips to/from species
    assert_equal 2, trips(:trip_one).taxons.length
    assert_equal 2, trips(:trip_two).taxons.length
  end

  def test_taxon_trips
    assert_equal 2, taxons(:taxon_one).trips.length
    assert_equal 2, taxons(:taxon_two).trips.length
  end

  def test_trip_locations
    # trips to/from location
    assert_equal 2, trips(:trip_one).locations.length
    assert_equal 2, trips(:trip_two).locations.length
  end

  def test_location_trips
    assert_equal 2, locations(:location_one).trips.length
    assert_equal 2, locations(:location_two).trips.length
  end
  
  def test_country_trips
    assert_equal 2, counties(:county_one).trips.length
    assert_equal 2, counties(:county_two).trips.length
  end

  def test_county_taxons
    assert_equal 1, counties(:county_one).taxons.length
    assert_equal 1, counties(:county_two).taxons.length
  end

  def test_state_trips
    assert_equal 2, states(:state_one).trips.length
    assert_equal 2, states(:state_two).trips.length
  end

  def test_state_taxons
    assert_equal 1, states(:state_one).taxons.length
    assert_equal 1, states(:state_two).taxons.length
  end

  def test_state_locations
    assert_equal 1, states(:state_one).locations.length
    assert_equal 1, states(:state_two).locations.length
  end
end
