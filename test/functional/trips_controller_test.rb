require File.dirname(__FILE__) + '/../test_helper'
require 'trips_controller'

# Re-raise errors caught by the controller.
class TripsController; def rescue_action(e) raise e end; end

class TripsControllerTest < Test::Unit::TestCase
  fixtures :trips

  def setup
    @controller = TripsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
                                                       
    @first_id = trips(:trip_one).id
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

    assert_not_nil assigns(:trips)
  end

  def test_list_biggest
    get :list_biggest

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'list_biggest'

    assert_not_nil assigns(:trips)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'show'

    assert_not_nil assigns(:trip)
    assert assigns(:trip).valid?
  end

  def test_new
    get :new, {}, {:username => 'testuser', :login_time => Time.now.to_i} 

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'new'

    assert_not_nil assigns(:trip)
  end

  def test_create
    num_trips = Trip.count

    post :create, {:trip => {:name => 'new trip', :date => '2007-01-01', :leader => 'new guy'}}, {:username => 'testuser', :login_time => Time.now.to_i} 

    assert_response :redirect
    assert_valid_xml(@response.body)                                                  
    
    new_trip_id = Trip.find_by_name("new trip").id
    assert_redirected_to :action => 'show', :controller => 'trips', :id => new_trip_id

    assert_equal num_trips + 1, Trip.count
  end

  def test_edit
    get :edit, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'edit'

    assert_not_nil assigns(:trip)
    assert assigns(:trip).valid?
  end

  def test_add_species
    get :add_species, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'add_species'

    assert_not_nil assigns(:trip)
    assert assigns(:trip).valid?
  end

  def test_update
    post :update, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}
    assert_response :redirect
    assert_valid_xml(@response.body)
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Trip.find(@first_id)
    }

    post :destroy, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}
    assert_response :redirect
    assert_valid_xml(@response.body)
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Trip.find(@first_id)
    }
  end
end
