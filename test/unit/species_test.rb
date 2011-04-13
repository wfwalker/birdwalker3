require File.dirname(__FILE__) + '/../test_helper'
require 'species'

class SpeciesTest < ActiveSupport::TestCase
  fixtures :species, :families, :photos, :locations, :trips, :sightings

  def setup
    @first_id = species(:species_one).id
  end

  # Replace this with your real tests.
  def test_fixtures
    assert Species.count == 2
  end           
  
  def test_common
    assert_equal false, Species.find(@first_id).common?, "sample test species should not be common"
  end      
  
  def test_find_all_countable_photographed
    assert_equal 2, Species.countable.photographed.size, "test fixture has two countable, photographed species"
  end

  def test_find_all_photographed
    assert_equal 2, Species.photographed.size, "test fixture has two photographed species"
  end
  
  def test_sightings
    assert_equal 2, Species.find(@first_id).sightings.size, "test fixture has two sightings for this species"
  end

  def test_locations
    assert_equal 1, Species.find(@first_id).locations.size, "test fixture has one location for this species"
  end

  def test_trips
    assert_equal 2, Species.find(@first_id).trips.size, "test fixture has two trips for this species"
  end

  def test_photos
    assert_equal 1, Species.find(@first_id).photos.size, "test fixture has one photos for this species"
  end
  
end
