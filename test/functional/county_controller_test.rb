require File.dirname(__FILE__) + '/../test_helper'
require 'county_controller'

# Re-raise errors caught by the controller.
class CountyController; def rescue_action(e) raise e end; end

class CountyControllerTest < Test::Unit::TestCase
  def setup
    @controller = CountyController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
