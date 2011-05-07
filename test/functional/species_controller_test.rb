require File.dirname(__FILE__) + '/../test_helper'
require 'species_controller'

# Re-raise errors caught by the controller.
class SpeciesController; def rescue_action(e) raise e end; end

class SpeciesControllerTest < ActionController::TestCase
  fixtures :species, :families, :photos, :sightings, :trips, :locations

  def setup
    @controller = SpeciesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = species(:species_one).id
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

    assert_not_nil assigns(:all_species_seen)
  end
                
  def test_year_list
    get :year_list, :year => 2007

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'list'

    assert_not_nil assigns(:all_species_seen)       
    assert_equal 2, assigns(:all_species_seen).length, "wrong number of species for 2007"
  end

  def test_life_list
    get :life_list

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'life_list'

    assert_not_nil assigns(:life_sightings)
  end

  def test_photo_life_list
    get :photo_life_list

    assert_response :success
    xml_document = assert_valid_xml(@response.body)
    assert_valid_document_title(xml_document, "birdWalker | Photo Life List")
    assert_template 'photo_life_list'

    assert_not_nil assigns(:all_species_photographed)
  end

  def test_photo_to_do_list
    get :photo_to_do_list

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'photo_to_do_list'

    assert_not_nil assigns(:all_species_not_photographed)
  end

  def test_show
    get :show, :id => @first_id     
    
    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'show'

    assert_not_nil assigns(:species)
    assert assigns(:species).valid?
  end

  def test_new
    get :new, {}, {:username => 'testuser', :login_time => Time.now.to_i}

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'new'

    assert_not_nil assigns(:species)
  end

  def test_create
    num_species = Species.count

    post :create, {:species => {:abbreviation => 'abcdef', :latin_name => 'Latinus', :common_name => 'Common'}}, {:username => 'testuser', :login_time => Time.now.to_i}

    assert_response :redirect
    assert_redirected_to :action => 'list'
    assert_valid_xml(@response.body)

    assert_equal num_species + 1, Species.count
  end

  def test_edit
    get :edit, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}

    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'edit'

    assert_not_nil assigns(:species)
    assert assigns(:species).valid?
  end

  def test_update
    post :update, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id

    # note: we're not testing the response for xml validity, since it's a redirect 
  end

  def test_destroy
    assert_nothing_raised {
      Species.find(@first_id)
    }

    post :destroy, {:id => @first_id}, {:username => 'testuser', :login_time => Time.now.to_i}
    assert_response :redirect
    assert_valid_xml(@response.body)
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Species.find(@first_id)
    }
  end
end
