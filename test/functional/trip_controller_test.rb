require File.dirname(__FILE__) + '/../test_helper'
require 'trip_controller'

# Re-raise errors caught by the controller.
class TripController; def rescue_action(e) raise e end; end

class TripControllerTest < Test::Unit::TestCase
  def setup
    @controller = TripController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
