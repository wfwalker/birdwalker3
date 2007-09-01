require File.dirname(__FILE__) + '/../test_helper'
require 'trips_controller'

# Re-raise errors caught by the controller.
class TripsController; def rescue_action(e) raise e end; end

class TripsControllerTest < Test::Unit::TestCase
  def setup
    @controller = TripsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
