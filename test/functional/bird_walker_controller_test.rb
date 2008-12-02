require File.dirname(__FILE__) + '/../test_helper'
require 'bird_walker_controller'
require 'application_helper'

# Re-raise errors caught by the controller.
class BirdWalkerController; def rescue_action(e) raise e end; end

class BirdWalkerControllerTest < Test::Unit::TestCase
  def setup
    @controller = BirdWalkerController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_about
    get :about
    assert_response :success
    assert_valid_xml(@response.body)
  end

  def test_index
    get :index
    assert_response :success
    assert_valid_xml(@response.body)
  end

  def test_root_routing
    assert_generates("/", :controller => "bird_walker", :action => "index")
    assert_generates("", :controller => "bird_walker", :action => "index")
  end
end
