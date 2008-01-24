require File.dirname(__FILE__) + '/../test_helper'

class SightingTest < Test::Unit::TestCase
  fixtures :sightings

  def test_associations
    @location = Location.create(:name => 'bird park', :count => 'bird county')
    @species = Species.create
    @species.save
    @trip = Trip.create
    @trip.save

    @sighting = Sighting.create    
    @sighting.trip_id = @trip.id
    @sighting.species_id = @species.id
    @sighting.location_id = @location.id
    @sighting.save
    @sighting.reloadload
    
    @location.reload
    @species.reload
    @trip.reload
    
    assert_equal 1, @location.sightings.size
  end
end
