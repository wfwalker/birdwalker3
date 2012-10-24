ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
# require File.expand_path('/helper_testcase', __FILE__)
require 'rails/test_help'
   
require "rexml/document"
require "rexml/element"
require "rexml/xmldecl"
require "rexml/text"

include REXML

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Add more helper methods to be used by all tests here...  
  
  
   def assert_valid_xml(some_stuff) 
     begin                                       
       return Document.new(some_stuff)     
     rescue REXML::ParseException
       fail "Invalid XML: " + ($!).to_s() + "\n-----------------------------\n\n"
     end
   end

   def assert_valid_document_title(xml_document, expected_title)
     if xml_document != nil then
       assert_equal 1, xml_document.get_elements("html").size(), "root tag should be 'html'"
       
       assert_equal 1, xml_document.get_elements("html/head/title").size(), "html head should have a title"
       assert_equal expected_title, xml_document.get_elements("html/head/title")[0].text, "title tag should match expected"

       assert_equal 1, xml_document.get_elements("html/body/div[@class='container']").size(), "html body should contain container div"
       assert_equal 1, xml_document.get_elements("html/body/div[@class='container']/div[@class='lead']").size(), "container div should contain lead div"
     end
   end

end
