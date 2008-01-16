class BirdWalkerController < ApplicationController
  helper :trips
  
  def index
    @recent_trips = Trip.find(:all, :limit => 10, :order => 'date DESC')
  end

  def about
  end
  
  def page_kind
    "home"
  end
end
