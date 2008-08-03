require File.dirname(__FILE__) + '/../test_helper'
require 'states_controller'

# Re-raise errors caught by the controller.
class StatesController; def rescue_action(e) raise e end; end

class StatesControllerTest < Test::Unit::TestCase
  fixtures :counties, :states

  def setup
    @controller = StatesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @first_id = states(:state_one).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:states)
  end  
  
  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:state)
    assert assigns(:state).valid?
  end
end
