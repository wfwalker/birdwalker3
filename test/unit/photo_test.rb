require File.dirname(__FILE__) + '/../test_helper'
require 'photo'

class PhotoTest < ActiveSupport::TestCase
  fixtures :photos, :locations, :species, :trips

  def setup
    @first_id = photos(:photo_one).id
  end

  def test_find_by_trip_id
    two_photos = Photo.find_all_by_trip_id(trips(:trip_one))
    assert_equal 2, two_photos.count, "find_by_trip(:trip_one) should find two photos"

    no_photos = Photo.find_all_by_trip_id(trips(:trip_two))
    assert_equal 0, no_photos.count, "find_by_trip(:trip_one) should find two photos"
  end

  def test_thumb_hostname
    aPhoto = Photo.find(@first_id)
    assert_no_match /localhost/, aPhoto.thumb(), "thumb URL with no argument should NOT contain hostname (i. e., localhost)"
    assert_no_match /http/, aPhoto.thumb(), "thumb URL with no argument should NOT 'http', since it should just be relative"
    
    assert_match /localhost/, aPhoto.thumb('localhost'), "thumb URL should contain hostname (i. e., localhost)"
  end
end
