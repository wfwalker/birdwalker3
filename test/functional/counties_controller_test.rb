require File.dirname(__FILE__) + '/../test_helper'
require 'counties_controller'

# Re-raise errors caught by the controller.
class CountiesController; def rescue_action(e) raise e end; end

class CountiesControllerTest < Test::Unit::TestCase
  fixtures :counties

  def setup
    @controller = CountiesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:counties)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_county
    old_count = County.count
    post :create, :county => { }
    assert_equal old_count+1, County.count
    
    assert_redirected_to county_path(assigns(:county))
  end

  def test_should_show_county
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_county
    put :update, :id => 1, :county => { }
    assert_redirected_to county_path(assigns(:county))
  end
  
  def test_should_destroy_county
    old_count = County.count
    delete :destroy, :id => 1
    assert_equal old_count-1, County.count
    
    assert_redirected_to counties_path
  end
end
