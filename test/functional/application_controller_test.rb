require File.dirname(__FILE__) + '/../test_helper'

# Re-raise errors caught by the controller.
class ApplicationController; def rescue_action(e) raise e end; end

class ApplicationControllerTest < ActionController::TestCase
  def setup
    @controller = ApplicationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_always_passes
    assert true
  end
end
