require File.dirname(__FILE__) + '/../test_helper'
require 'species_controller'

# Re-raise errors caught by the controller.
class SpeciesController; def rescue_action(e) raise e end; end

class SpeciesControllerTest < Test::Unit::TestCase
  fixtures :species, :families

  def setup
    @controller = SpeciesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = species(:species_one).id
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

    assert_not_nil assigns(:all_species_seen)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:species)
    assert assigns(:species).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:species)
  end

  def test_create
    num_species = Species.count

    post :create, :species => {:abbreviation => 'abcdef', :latin_name => 'Latinus', :common_name => 'Common'}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_species + 1, Species.count
  end

  def test_edit
    get :edit, {:id => @first_id}, {:username => 'testuser'}

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:species)
    assert assigns(:species).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Species.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Species.find(@first_id)
    }
  end
end
