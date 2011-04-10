require File.dirname(__FILE__) + '/../test_helper'

class LocationTest < Test::Unit::TestCase
  fixtures :photos, :locations, :species, :trips, :sightings, :counties, :states

  def setup
    @first_id = locations(:location_one).id
    @second_id = locations(:location_two).id
  end

  def test_abbreviation
    aLocation = Location.find(@first_id)
    
    # abbreviation for "First Place" is "FP"
    assert_equal aLocation.name, "First Place"
    assert_equal aLocation.abbreviation, "FP"
  end
  
  def test_sightings
    assert_equal 2, Location.find(@first_id).sightings.size, "test fixture has two sightings for this location"
  end

  def test_species
    assert_equal 1, Location.find(@first_id).species.size, "test fixture has one species for this location"
  end

  def test_trips
    assert_equal 2, Location.find(@first_id).trips.size, "test fixture has two trips for this location"
  end

  def test_photos
    assert_equal 1, Location.find(@first_id).photos.size, "test fixture has one photos for this location"
  end   
  
  def test_distance_in_miles_from
    assert Location.find(@first_id).distance_in_miles_from(Location.find(@second_id)) < 5, "Charleston Slough should be less than five miles from Palo Alto Duck Pond"
  end     
  
  def test_sunrise_sunset
    Location.find(@first_id).sunrise(Date.today).localtime
    Location.find(@first_id).sunset(Date.today).localtime
  end
end
