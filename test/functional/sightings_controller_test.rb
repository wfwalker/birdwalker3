require File.dirname(__FILE__) + '/../test_helper'
require 'sightings_controller'

# Re-raise errors caught by the controller.
class SightingsController; def rescue_action(e) raise e end; end

class SightingsControllerTest < Test::Unit::TestCase
  def setup
    @controller = SightingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
