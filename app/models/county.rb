class County < ActiveRecord::Base
  attr_accessor :name
  attr_accessor :locations
  
  def initialize(name)
    @name = name
    @locations = Location.find(:all, :conditions => ["County = ?", @name])
  end
end
