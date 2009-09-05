require File.dirname(__FILE__) + '/../test_helper'

class FamilyTest < Test::Unit::TestCase
  fixtures :photos, :locations, :species, :trips, :sightings, :counties, :states, :families
  
  def setup
    @first_id = families(:family_one).id
  end
  
  def test_sightings
    assert_equal 2, Family.find(@first_id).sightings.size, "test fixture has two sightings for this family"
  end

  def test_species
    assert_equal 1, Family.find(@first_id).species.size, "test fixture has one species for this family"
  end

  def test_locations
    assert_equal 1, Family.find(@first_id).locations.size, "test fixture has one location for this family"
  end

  def test_trips
    assert_equal 2, Family.find(@first_id).trips.size, "test fixture has two trips for this family"
  end

  def test_photos
    assert_equal 1, Family.find(@first_id).photos.size, "test fixture has one photos for this family"
  end
end
