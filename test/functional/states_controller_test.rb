require File.dirname(__FILE__) + '/../test_helper'
require 'states_controller'

# Re-raise errors caught by the controller.
class StatesController; def rescue_action(e) raise e end; end

class StatesControllerTest < Test::Unit::TestCase
  def setup
    @controller = StatesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
