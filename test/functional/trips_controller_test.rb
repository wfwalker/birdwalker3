require File.dirname(__FILE__) + '/../test_helper'
require 'trips_controller'

# Re-raise errors caught by the controller.
class TripsController; def rescue_action(e) raise e end; end

class TripsControllerTest < ActionController::TestCase
  fixtures :trips

  def setup
    @controller = TripsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
                                                       
    @first_id = trips(:trip_one).id
    @second_id = trips(:trip_two).id
  end

  def test_index
    get :index
    assert_response :success
    xml_document = assert_valid_xml(@response.body)
    assert_valid_document_title(xml_document, "birdWalker | Trips")
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    xml_document = assert_valid_xml(@response.body)
    assert_valid_document_title(xml_document, "birdWalker | Trips")
    assert_template 'list'

    assert_not_nil assigns(:trips)
  end

  def test_list_biggest
    get :list_biggest

    assert_response :success
    xml_document = assert_valid_xml(@response.body)
    assert_valid_document_title(xml_document, "birdWalker | Biggest Trips")
    assert_template 'list_biggest'

    assert_not_nil assigns(:trips)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    xml_document = assert_valid_xml(@response.body)
    assert_valid_document_title(xml_document, "birdWalker | First Trip")
    assert_template 'show'
    assert_not_nil assigns(:trip)
    assert assigns(:trip).valid?
  end

  def test_show_notes_with_html_tags
    get :show, :id => @second_id

    assert_response :success
    xml_document = assert_valid_xml(@response.body)
    assert_valid_document_title(xml_document, "birdWalker | Second Trip")
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
    xml_document = assert_valid_xml(@response.body)
    
    new_trip_id = Trip.find_by_name("new trip").id
    assert_redirected_to :action => 'show', :controller => 'trips', :id => new_trip_id

    assert_equal num_trips + 1, Trip.count
  end

  def test_edit
    get :edit, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}

    assert_response :success
    xml_document = assert_valid_xml(@response.body)
    assert_valid_document_title(xml_document, "birdWalker | First Trip")
    assert_template 'edit'

    assert_not_nil assigns(:trip)
    assert assigns(:trip).valid?
  end

  def test_add_species
    get :add_species, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}

    assert_response :success
    xml_document = assert_valid_xml(@response.body)
    assert_valid_document_title(xml_document, "birdWalker | First Trip")
    assert_template 'add_species'

    assert_not_nil assigns(:trip)
    assert assigns(:trip).valid?
  end

  def test_update
    originalTrip = Trip.find(@first_id)
    assert_equal "First Trip", originalTrip.name, "original trip name should match"
    assert_nil originalTrip.notes, "trip notes should be nil"

    post :update, {:id => @first_id, :trip => {:name => "First Trip Updated", :notes => 'Updated'}}, {:username => 'testuser', :login_time => Time.now.to_i}
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id

    # note: we're not testing the response for xml validity, since it's a redirect 
    # but we are testing the values in the updated record
    
    updatedTrip = Trip.find(@first_id)
    assert_equal "First Trip Updated", updatedTrip.name, "updated trip name should match"
    assert_not_nil updatedTrip.notes, "updated trip notes should be nil"
    assert_equal "Updated", updatedTrip.notes, "updated trip notes should be updated"
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
  
  def test_show_as_ebird_record_format
    get :show_as_ebird_record_format, {:id => @first_id}
    assert_equal "Dodo,,,2,,First Place,37.4348,-122.099,01/01/2007,,FS,US,casual,,,Y,,,\nIvory-billed Woodpecker,,,X,,Second Place,37.4573,-122.109,01/01/2007,,SS,US,casual,,,Y,,,", @response.body, "ebird text should match"
  end
end
