require File.dirname(__FILE__) + '/../../test_helper'

class ApplicationHelperTest < ActiveSupport::TestCase

  include ApplicationHelper

  fixtures :sightings

  def setup
    #super
  end
  
  def test_always_passes
    # do nothing - required by test/unit
  end
end
