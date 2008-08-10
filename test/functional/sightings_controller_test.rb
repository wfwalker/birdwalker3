require File.dirname(__FILE__) + '/../test_helper'
require 'sightings_controller'

# Re-raise errors caught by the controller.
class SightingsController; def rescue_action(e) raise e end; end

class SightingsControllerTest < Test::Unit::TestCase
  fixtures :trips, :sightings, :locations

  def setup
    @controller = SightingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = sightings(:sighting_one).id
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:sighting)
    assert assigns(:sighting).valid?
  end

  def test_new
    get :new, {}, {:username => 'testuser'} 

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:sighting)
  end

  def test_create
    num_sightings = Sighting.count

    post :create, {:sighting => {:trip_id => 1, :location_id => 1, :species_id => 1}}, {:username => 'testuser'} 

    assert_response :redirect
    assert_redirected_to :action => 'edit'

    assert_equal num_sightings + 1, Sighting.count
  end

  def test_edit
    get :edit, {:id => @first_id}, {:username => 'testuser'}

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:sighting)
    assert assigns(:sighting).valid?
  end

  def test_update
    post :update, {:id => @first_id}, {:username => 'testuser'}
    assert_response :redirect
    # redirected to edit trip
    assert_redirected_to :action => 'edit'
  end

  def test_destroy
    assert_nothing_raised {
      Sighting.find(@first_id)
    }

    post :destroy, {:id => @first_id}, {:username => 'testuser'}
    assert_response :redirect             
    
    # redirected to edit trip
    assert_redirected_to :action => 'edit'

    assert_raise(ActiveRecord::RecordNotFound) {
      Sighting.find(@first_id)
    }
  end
end
