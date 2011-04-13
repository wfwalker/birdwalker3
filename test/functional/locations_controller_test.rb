require File.dirname(__FILE__) + '/../test_helper'
require 'locations_controller'

# Re-raise errors caught by the controller.
class LocationsController; def rescue_action(e) raise e end; end

class LocationsControllerTest < ActionController::TestCase
  fixtures :locations, :counties, :photos, :sightings, :states, :trips, :species, :families

  def setup
    @controller = LocationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = locations(:location_one).id
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

    assert_not_nil assigns(:locations)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'show_rare'

    assert_not_nil assigns(:location)
    assert assigns(:location).valid?
  end
  
  def test_show_species_by_year
    get :show_species_by_year, :id => @first_id

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'show_species_by_year'

    assert_not_nil assigns(:location)
    assert assigns(:location).valid?
  end
  
  def test_show_species_by_month
    get :show_species_by_month, :id => @first_id

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'show_species_by_month'

    assert_not_nil assigns(:location)
    assert assigns(:location).valid?
  end
                                                          
  def test_new
    get :new, {}, {:username => 'testuser', :login_time => Time.now.to_i}

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'new'

    assert_not_nil assigns(:location)
  end

  def test_create
    num_location = Location.count

    post :create, {:location => {:name => 'some cool birding place', :county_id => 1}}, {:username => 'testuser', :login_time => Time.now.to_i}
 
    assert flash[:error] == nil
    
# TODO: why does this not render with 'show_rare_'
    # assert_template 'show_rare'                 
    
    assert_valid_xml(@response.body)
    assert_equal num_location + 1, Location.count
  end

  def test_edit
    get :edit, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'edit'

    assert_not_nil assigns(:location)
    assert assigns(:location).valid?
  end

  def test_update
    originalLocation = Location.find(@first_id)
    assert_equal "First Place", originalLocation.name, "original location name should match"
    assert_equal "lat and long from Charleston Slough", originalLocation.notes

    post :update, {:id => @first_id, :location => {:name => 'First Place Updated', :notes => "Updated"}}, {:username => 'testuser', :login_time => Time.now.to_i}
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id

    # note: we're not testing the response for xml validity, since it's a redirect 
    # but we are testing the values in the updated record

    updatedLocation = Location.find(@first_id)
    assert_equal "First Place Updated", updatedLocation.name, "updated location name should match"
    assert_not_nil updatedLocation.notes, "updated location notes should not be nil"
    assert_equal "Updated", updatedLocation.notes, "updated location notes should be updated"
  end

  def test_destroy
    assert_nothing_raised {
      Location.find(@first_id)
    }

    post :destroy, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}
    assert_response :redirect
    assert_valid_xml(@response.body)
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Location.find(@first_id)
    }
  end     
  
  def test_locations_near
    originalLocation = Location.find(@first_id)
    get :locations_near, {:lat => originalLocation.latitude, :long => originalLocation.longitude, :miles => 1 }
    assert @response.body.include?("First Place"), "JSON results for nearby server should contain 'First Place'"
  end
end
