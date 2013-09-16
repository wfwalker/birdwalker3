require File.dirname(__FILE__) + '/../test_helper'
require 'photo'

class PhotoTest < ActiveSupport::TestCase
  fixtures :photos, :locations, :trips, :taxons

  def setup
    @first = photos(:photo_one)
    @second = photos(:photo_two)
    @third = photos(:photo_three)
  end

  def test_image_filename
    assert_equal "2007-01-01-dodo-aaa.jpg", @first.image_filename, "image filename uses abbreviation and original filename if available"
    assert_equal "2007-01-01-ivbwoo.jpg", @second.image_filename, "image filename uses abbreviation, omits missing original filename"
    assert_equal "2007-02-01-latinus_international.jpg", @third.image_filename, "image filename uses abbreviation, omits missing original filename"
  end

  def test_find_by_trip_id
    two_photos = Photo.find_all_by_trip_id(trips(:trip_one))
    assert_equal 2, two_photos.count, "find_by_trip(:trip_one) should find two photos"

    no_photos = Photo.find_all_by_trip_id(trips(:trip_two))
    assert_equal 1, no_photos.count, "find_by_trip(:trip_two) should find two photos"
  end

  def test_thumb_hostname
    assert_no_match /localhost/, @first.thumb(), "thumb URL with no argument should NOT contain hostname (i. e., localhost)"
    assert_no_match /http/, @first.thumb(), "thumb URL with no argument should NOT 'http', since it should just be relative"
    
    assert_match /localhost/, @first.thumb('localhost'), "thumb URL should contain hostname (i. e., localhost)"
  end
end
