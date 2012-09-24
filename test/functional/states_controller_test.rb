require File.dirname(__FILE__) + '/../test_helper'
require 'states_controller'

# Re-raise errors caught by the controller.
class StatesController; def rescue_action(e) raise e end; end

class StatesControllerTest < ActionController::TestCase
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
    assert_valid_xml(@response.body)
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'list'

    assert_not_nil assigns(:states)
  end  
  
  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'show'

    assert_not_nil assigns(:state)
    assert assigns(:state).valid?
  end                    

  def test_show_chronological_list
    get :show_chronological_list, :id => @first_id

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'states/show_chronological_list'

    assert_not_nil assigns(:state)
    assert assigns(:state).valid?
  end                    
  
  def test_show_species_by_year
    get :show_species_by_year, :id => @first_id

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'show_species_by_year'

    assert_not_nil assigns(:state)
    assert assigns(:state).valid?
  end
end
