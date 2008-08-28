require File.dirname(__FILE__) + '/../test_helper'
require 'families_controller'

# Re-raise errors caught by the controller.
class FamiliesController; def rescue_action(e) raise e end; end

class FamiliesControllerTest < Test::Unit::TestCase
  fixtures :families

  def setup
    @controller = FamiliesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = families(:family_one).id
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

    assert_not_nil assigns(:families)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'show_rare'

    assert_not_nil assigns(:family)
    assert assigns(:family).valid?
  end

  def test_new
    get :new, {}, {:username => 'testuser'} 

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'new'

    assert_not_nil assigns(:family)
  end

  def test_create
    num_families = Family.count

    post :create, {:family => {}}, {:username => 'testuser'}

    assert_response :redirect
    assert_valid_xml(@response.body)
    assert_redirected_to :action => 'list'

    assert_equal num_families + 1, Family.count
  end

  def test_edit
    get :edit, {:id => @first_id}, {:username => 'testuser'} 

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'edit'

    assert_not_nil assigns(:family)
    assert assigns(:family).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_valid_xml(@response.body)
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Family.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_valid_xml(@response.body)
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Family.find(@first_id)
    }
  end
end
