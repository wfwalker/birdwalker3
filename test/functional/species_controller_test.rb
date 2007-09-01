require File.dirname(__FILE__) + '/../test_helper'
require 'species_controller'

# Re-raise errors caught by the controller.
class SpeciesController; def rescue_action(e) raise e end; end

class SpeciesControllerTest < Test::Unit::TestCase
  def setup
    @controller = SpeciesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
