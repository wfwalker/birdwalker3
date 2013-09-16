require File.dirname(__FILE__) + '/../test_helper'
require 'photos_controller'

# Re-raise errors caught by the controller.
class PhotosController; def rescue_action(e) raise e end; end

class PhotosControllerTest < ActionController::TestCase
  fixtures :trips, :photos, :locations, :taxons, :counties, :states, :countries

  def setup
    @controller = PhotosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = photos(:photo_one).id
  end   
  
  def test_index
    get :index
    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'index'
  end

  def test_recent_gallery
    get :recent_gallery
    assert_response :success
    xml_document = assert_valid_xml(@response.body)
    assert_template 'recent_gallery'
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'show'

    assert_not_nil assigns(:photo)
    assert assigns(:photo).valid?
  end

  def test_show_by_date
    get :show_by_date, :year => 2007, :month => 1, :day => 1, :abbreviation => 'dodo', :originalfilename => 'aaa'
    assert_response :success
  end

  def test_show_json
    get :show, :id => @first_id, :format => 'json'
    assert @response.body.include?('aaa'), "JSON results '" + @response.body + "' should include original file name"
  end  

  def test_new
    get :new, {}, {:username => 'testuser', :login_time => Time.now.to_i} 

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'new'

    assert_not_nil assigns(:photo)
  end

  def test_create
    num_photos = Photo.count

    post :create, {:photo => {:trip_id => 1, :location_id => 1, :taxon_latin_name => 'Latinus latinae'}}, {:username => 'testuser', :login_time => Time.now.to_i} 

    assert_response :redirect
    assert_valid_xml(@response.body)
    
    assert_redirected_to :id => 1, :controller => 'trips', :action => 'edit'
    assert_equal num_photos + 1, Photo.count
  end

  def test_edit
    get :edit, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'edit'

    assert_not_nil assigns(:photo)
    assert assigns(:photo).valid?
  end

  def test_update
    post :update, {:id => @first_id, :photo => {:trip_id => 24, :original_filename => 'MyString2'}}, {:username => 'testuser', :login_time => Time.now.to_i}
    assert_response :redirect
    assert_redirected_to :action => 'show'

    # note: we're not testing the response for xml validity, since it's a redirect 
    
    assert_equal 24, Photo.find(@first_id).trip_id
    assert_equal "MyString2", Photo.find(@first_id).original_filename
  end

  def test_destroy
    num_photos = Photo.count
 
    assert_nothing_raised {
      Photo.find(@first_id)
    }

    post :destroy, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}
    assert_response :redirect             
    assert_valid_xml(@response.body)

    assert_redirected_to :id => 1, :controller => 'trips', :action => 'edit'
    assert_equal num_photos - 1, Photo.count
    
    # redirected to edit trip #1
    assert_redirected_to :controller => 'trips', :id => 1, :action => 'edit'

    assert_raise(ActiveRecord::RecordNotFound) {
      Photo.find(@first_id)
    }
  end
end
