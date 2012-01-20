require File.dirname(__FILE__) + '/../test_helper'
require 'sightings_controller'

# Re-raise errors caught by the controller.
class SightingsController; def rescue_action(e) raise e end; end

class SightingsControllerTest < ActionController::TestCase
  fixtures :trips, :sightings, :locations, :species

  def setup
    @controller = SightingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = sightings(:sighting_one).id
  end

  def test_show
    get :show, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'show'

    assert_not_nil assigns(:sighting)
    assert assigns(:sighting).valid?
  end

  def test_new
    get :new, {}, {:username => 'testuser', :login_time => Time.now.to_i}

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'new'

    assert_not_nil assigns(:sighting)
  end

  def test_create
    num_sightings = Sighting.count

    post :create, {:sighting => {:trip_id => 1, :location_id => 1, :species_id => 1}}, {:username => 'testuser', :login_time => Time.now.to_i} 

    assert_response :redirect
    assert_valid_xml(@response.body)
    assert_redirected_to :controller => 'trips', :id => 1, :action => 'edit'

    assert_equal num_sightings + 1, Sighting.count
  end

  def test_create_list
    num_sightings = Sighting.count

    post :create_list, {:sighting => {:trip_id => 3, :location_id => 1}, :abbreviation_list => "dodo ivbwoo"}, {:username => 'testuser', :login_time => Time.now.to_i}

    assert_response :redirect
    assert_valid_xml(@response.body)
    assert_redirected_to :controller => 'trips', :id => 3, :action => 'show'

    assert_equal num_sightings + 2, Sighting.count
  end

  def test_edit
    get :edit, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'edit'

    assert_not_nil assigns(:sighting)
    assert assigns(:sighting).valid?
  end

  def test_update
    post :update, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}
    assert_response :redirect
    assert_redirected_to :controller => 'trips', :id => 1, :action => 'show'

    # note: we're not testing the response for xml validity, since it's a redirect 
  end

  def test_destroy
    assert_nothing_raised {
      Sighting.find(@first_id)
    }

    post :destroy, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}
    assert_response :redirect             
    assert_valid_xml(@response.body)
    
    # redirected to edit trip
    assert_redirected_to :controller => 'trips', :id => 1, :action => 'show'

    assert_raise(ActiveRecord::RecordNotFound) {
      Sighting.find(@first_id)
    }
  end
end
