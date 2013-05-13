require File.dirname(__FILE__) + '/../test_helper'
require 'families_controller'

# Re-raise errors caught by the controller.
class FamiliesController; def rescue_action(e) raise e end; end

class FamiliesControllerTest < ActionController::TestCase
end
