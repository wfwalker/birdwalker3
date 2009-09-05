require File.dirname(__FILE__) + '/../test_helper'
require 'bird_walker_controller'
require 'application_helper'

# Re-raise errors caught by the controller.
class BirdWalkerController; def rescue_action(e) raise e end; end

class BirdWalkerControllerTest < Test::Unit::TestCase
  fixtures :species, :families, :photos, :locations, :sightings, :counties, :states, :trips

  def setup
    @controller = BirdWalkerController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_about
    get :about
    assert_response :success  
    assert_valid_xml(@response.body)  
    assert_template 'about'
  end

  def test_index
    get :index
    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'index'
  end

  def test_index_rss
    get :index_rss
    assert_response :success
    assert_valid_xml(@response.body)
    assert_template 'app/views/bird_walker/index_rss.rxml'
  end
  
#  def test_sialia_rss
#    get :sialia_rss
#    assert_response :success
#    assert_valid_xml(@response.body)
#  end

  def test_search_redirect_to_species
    get(:search, :terms => 'Wood')
    assert_response 302
  end

  def test_search_redirect_to_trip
    get(:search, :terms => 'First Trip')
    assert_response 302
  end

  def test_search_redirect_to_location
    get(:search, :terms => 'First Place')
    assert_response 302
  end

  def test_search_two_locations
    get(:search, :terms => 'Place')
    assert @response.body.include?("2 Locations")
    assert ! @response.body.include?("Trips")
    assert ! @response.body.include?("Species")
    assert_valid_xml(@response.body)    
    assert_template 'search'
  end

  def test_search_apostrophe_should_find_nothing
    get(:search, :terms => 'Clark\'s Grebe')
    assert ! @response.body.include?("Locations")
    assert ! @response.body.include?("Trips")
    assert ! @response.body.include?("Species")
    assert_valid_xml(@response.body)    
    assert_template 'search'
  end

  def test_search_empty_terms_should_find_nothing
    get(:search, :terms => '')
    assert ! @response.body.include?("Locations")
    assert ! @response.body.include?("Trips")
    assert ! @response.body.include?("Species")
    assert_valid_xml(@response.body)    
    assert_template 'search'
  end

  def test_search_no_terms
    get :search
    assert ! @response.body.include?("Locations")
    assert ! @response.body.include?("Trips")
    assert ! @response.body.include?("Species")
    assert_valid_xml(@response.body)    
    assert_template 'search'
  end

  def test_search_two_trips
    get :search, :terms => 'Trip'
    assert ! @response.body.include?("Locations")
    assert @response.body.include?("2 Trips")
    assert ! @response.body.include?("Species")
    assert_valid_xml(@response.body)    
    assert_template 'search'
  end

  def test_root_routing
    assert_generates("/", :controller => "bird_walker", :action => "index")
    assert_generates("", :controller => "bird_walker", :action => "index")
  end
end
