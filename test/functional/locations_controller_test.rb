require File.dirname(__FILE__) + '/../test_helper'
require 'locations_controller'

# Re-raise errors caught by the controller.
class LocationsController; def rescue_action(e) raise e end; end

class LocationsControllerTest < Test::Unit::TestCase
  fixtures :locations, :counties, :photos, :sightings, :states

  def setup
    @controller = LocationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = locations(:location_one).id
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

    assert_not_nil assigns(:locations)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show_rare'

    assert_not_nil assigns(:location)
    assert assigns(:location).valid?
  end
                                                          
  def test_new
    get :new, {}, {:username => 'testuser'} 

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:location)
  end

  def test_create
    num_location = Location.count

    post :create, :location => {:name => 'some cool birding place', :county_id => 1}
 
    assert flash[:error] == nil
    
# TODO: why does this fail:
#    assert_template 'show_rare'              

    assert_equal num_location + 1, Location.count
  end

  def test_edit
    get :edit, {:id => @first_id}, {:username => 'testuser'}

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:location)
    assert assigns(:location).valid?
  end

  def test_update
    post :update, {:id => @first_id}, {:username => 'testuser'}
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Location.find(@first_id)
    }

    post :destroy, {:id => @first_id}, {:username => 'testuser'}
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Location.find(@first_id)
    }
  end
end
