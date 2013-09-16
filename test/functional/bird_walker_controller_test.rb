require File.dirname(__FILE__) + '/../test_helper'
require 'bird_walker_controller'
require 'application_helper'

# Re-raise errors caught by the controller.
class BirdWalkerController; def rescue_action(e) raise e end; end

class BirdWalkerControllerTest < ActionController::TestCase
  fixtures :taxons, :photos, :locations, :sightings, :counties, :states, :trips

  def setup
    @controller = BirdWalkerController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_about
    get :about
    assert_response :success  
    xml_document = assert_valid_xml(@response.body)  
    assert_valid_document_title(xml_document, "birdWalker | About")
    assert_template 'about'
  end

  def test_index
    get :index
    assert_response :success
    xml_document = assert_valid_xml(@response.body)  
    assert_valid_document_title(xml_document, "birdWalker")
    assert_template 'index'
  end

  def test_index_rss
    get :index_rss
    assert_response :success
    assert_valid_xml(@response.body)
    # assert_template 'app/views/bird_walker/index_rss.xml'
  end
  
#  def test_sialia_rss
#    get :sialia_rss
#    assert_response :success
#    assert_valid_xml(@response.body)
#  end

  def test_search_redirect_to_taxon
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
    xml_document = assert_valid_xml(@response.body)  
    assert_equal 1, xml_document.get_elements("//div[@class='moduletitle'][text()='2 Locations']").size(), "there should a moduletitle for 2 locations"    
    assert_valid_document_title(xml_document, "birdWalker | search results")
    assert_template 'search'
  end

  def test_search_apostrophe_should_find_nothing
    get(:search, :terms => 'Clark\'s Grebe')
    xml_document = assert_valid_xml(@response.body)
    assert_equal 1, xml_document.get_elements("//div[@class='moduletitle']").size(), "there should be only one moduletitle for overall search results"
    assert_valid_document_title(xml_document, "birdWalker | search results")
    assert_template 'search'
  end

  def test_search_empty_terms_should_find_nothing
    get(:search, :terms => '')
    xml_document = assert_valid_xml(@response.body)  
    assert_equal 1, xml_document.get_elements("//div[@class='moduletitle']").size(), "there should be only one moduletitle for overall search results"
    assert_valid_document_title(xml_document, "birdWalker | search results")
    assert_template 'search'
  end

  def test_search_no_terms
    get :search
    xml_document = assert_valid_xml(@response.body)  
    assert_equal 1, xml_document.get_elements("//div[@class='moduletitle']").size(), "there should be only one moduletitle for overall search results"
    assert_valid_document_title(xml_document, "birdWalker | search results")
    assert_template 'search'
  end

  def test_search_two_trips
    get :search, :terms => 'Trip'
    xml_document = assert_valid_xml(@response.body)  
    assert_equal 1, xml_document.get_elements("//div[@class='moduletitle'][text()='2 Trips']").size(), "there should a moduletitle for 2 trips"    
    assert_valid_document_title(xml_document, "birdWalker | search results")
    assert_template 'search'
  end

  def test_root_routing
    assert_generates("/", :controller => "bird_walker", :action => "index")
    assert_generates("", :controller => "bird_walker", :action => "index")
  end
end
