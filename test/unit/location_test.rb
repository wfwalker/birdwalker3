require File.dirname(__FILE__) + '/../test_helper'

class LocationTest < ActiveSupport::TestCase
  fixtures :locations, :taxons, :trips, :sightings, :counties, :states, :photos

  def setup
    @first = locations(:location_one)
    @second = locations(:location_two)
  end

  def test_county_association
    assert_equal counties(:county_one), @first.county, "location_one is in county_one"
  end

  def test_abbreviation    
    # abbreviation for "First Place" is "FP"
    assert_equal @first.name, "First Place"
    assert_equal @first.abbreviation, "FP"
  end
  
  def test_sightings
    assert_equal 2, @first.sightings.length, "location_one has two sightings"
  end

  def test_taxon
    assert_equal 1, @first.taxons.length, "location_one has one taxon"
  end

  def test_trips
    assert_equal 2, @first.trips.length, "location_one has two trips"
  end

  def test_photos
    assert_equal 1, @first.photos.count, "location_one has one photo"
  end   
  
  def test_distance_in_miles_from
    assert @first.distance_in_miles_from(@second) < 5, "Charleston Slough should be less than five miles from Palo Alto Duck Pond"
  end     
  
  def test_sunrise_sunset
    @first.sunrise(Date.today).localtime
    @first.sunset(Date.today).localtime
  end
end
