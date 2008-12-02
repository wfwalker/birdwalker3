require File.dirname(__FILE__) + '/../../test_helper'

class ApplicationHelperTest < HelperTestCase

  include ApplicationHelper

  #fixtures :users, :articles

  def setup
    #super
  end
  
  def test_always_passes
    # do nothing - required by test/unit
  end
  
  def test_timeout
    session[:username] = 'pants'
  end
end
