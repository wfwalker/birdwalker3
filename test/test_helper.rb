ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require File.expand_path(File.dirname(__FILE__) + '/helper_testcase')

require 'test_help'
  
require "rexml/document"
require "rexml/element"
require "rexml/xmldecl"
require "rexml/text"

include REXML

class Test::Unit::TestCase
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
       if (some_stuff.include?("http://maps.google.com/maps")) then
         puts "WARNING: document contains google map, can't validate XML"
         return nil
       else         
         return Document.new(some_stuff)     
       end
       
     rescue REXML::ParseException
       fail "Invalid XML: " + $! + "\n\n\n\n-------------------" + some_stuff + "\n-----------------------------\n\n"
     end
   end

   def assert_valid_document_title(xml_document)
     if xml_document != nil then
       assert_equal 1, xml_document.get_elements("html").size(), "root tag should be 'html'"
       assert_equal 1, xml_document.get_elements("html/body/div[@id='pagebody']").size(), "html body should contain pagebody div"
       assert_equal 1, xml_document.get_elements("html/body/div[@id='pagebody']/div[@id='pageheader']").size(), "pagebody div should contain pageheader div"
       assert_equal 1, xml_document.get_elements("html/body/div[@id='pagebody']/div[@id='pageheader']/div[@id='pagetitle']").size(), "div containing title should be at expected path"
     end
   end

end
