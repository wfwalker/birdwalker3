require File.dirname(__FILE__) + '/../test_helper'
require 'photos_controller'

# Re-raise errors caught by the controller.
class PhotosController; def rescue_action(e) raise e end; end

class PhotosControllerTest < Test::Unit::TestCase
  fixtures :trips, :photos, :locations, :species

  def setup
    @controller = PhotosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = photos(:photo_one).id
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:photo)
    assert assigns(:photo).valid?
  end

  def test_new
    get :new, {}, {:username => 'testuser'} 

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:photo)
  end

  def test_create
    num_sightings = Photo.count

    post :create, {:photo => {:trip_id => 1, :location_id => 1, :species_id => 1}}, {:username => 'testuser'} 

    assert_response :redirect
    assert_redirected_to :action => 'edit'

    assert_equal num_sightings + 1, Photo.count
  end

  def test_edit
    get :edit, {:id => @first_id}, {:username => 'testuser'}

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:photo)
    assert assigns(:photo).valid?
  end

  def test_update
    post :update, {:id => @first_id}, {:username => 'testuser'}
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  def test_destroy
    assert_nothing_raised {
      Photo.find(@first_id)
    }

    post :destroy, {:id => @first_id}, {:username => 'testuser'}
    assert_response :redirect             
    
    # redirected to edit trip
    assert_redirected_to :action => 'edit'

    assert_raise(ActiveRecord::RecordNotFound) {
      Photo.find(@first_id)
    }
  end
end
