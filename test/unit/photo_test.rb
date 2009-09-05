require File.dirname(__FILE__) + '/../test_helper'
require 'photo'

class PhotoTest < Test::Unit::TestCase
  fixtures :photos, :locations, :species, :trips

  def setup
    @first_id = photos(:photo_one).id
  end

  def test_tiny_thumb_hostname
    aPhoto = Photo.find(@first_id)
    assert_no_match /localhost/, aPhoto.tiny_thumb(), "tiny_thumb URL with no argument should NOT contain hostname (i. e., localhost)"
    assert_no_match /http/, aPhoto.tiny_thumb(), "tiny_thumb URL with no argument should NOT 'http', since it should just be relative"
    
    assert_match /localhost/, aPhoto.tiny_thumb('localhost'), "tiny_thumb URL should contain hostname (i. e., localhost)"
  end
end
