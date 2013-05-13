require File.dirname(__FILE__) + '/../test_helper'
require 'species_controller'

# Re-raise errors caught by the controller.
class SpeciesController; def rescue_action(e) raise e end; end

class SpeciesControllerTest < ActionController::TestCase
end
