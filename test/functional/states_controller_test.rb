require File.dirname(__FILE__) + '/../test_helper'
require 'states_controller'

# Re-raise errors caught by the controller.
class StatesController; def rescue_action(e) raise e end; end

class StatesControllerTest < ActionController::TestCase
  fixtures :counties, :states, :countries

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

  def test_show_json
    get :show, :id => @first_id, :format => 'json'
    assert @response.body.include?('First State'), "JSON results '" + @response.body + "' should include state name"
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

  def test_new
    get :new, {}, {:username => 'testuser', :login_time => Time.now.to_i}

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'new'

    assert_not_nil assigns(:state)
  end

  def test_create
    num_counties = State.count

    post :create, {:state => {:name => 'newname', :abbreviation => 'ZZ', :country_id => 1}}, {:username => 'testuser', :login_time => Time.now.to_i}

    assert_response :redirect
    assert_valid_xml(@response.body)                              
    new_state_id = State.find_by_name("newname").id
    assert_redirected_to :id => new_state_id, :action => 'show'

    assert_equal num_counties + 1, State.count
  end

  def test_edit
    get :edit, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'edit'

    assert_not_nil assigns(:state)
    assert assigns(:state).valid?
  end

  def test_update
    post :update, {:id => @first_id, :state => {:name => 'updated', :country_id => 1}}, {:username => 'testuser', :login_time => Time.now.to_i}
    assert_response :redirect

    # note: we're not testing the response for xml validity, since it's a redirect 
    
    assert_redirected_to :action => 'show', :id => @first_id

    assert_equal "updated", State.find(@first_id).name
  end

  def test_destroy
    assert_nothing_raised {
      State.find(@first_id)
    }

    post :destroy, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}
    assert_response :redirect
    assert_valid_xml(@response.body)
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      State.find(@first_id)
    }
  end
end
