class BirdWalkerController < ApplicationController
  helper :trips
  
  def index
    @recent_trips = Trip.find(:all, :limit => 10, :order => 'date DESC')
    @bird_of_the_week = Species.bird_of_the_week
    @photo_of_the_week = @bird_of_the_week.photo_of_the_week
    @this_year_species = Species.year_to_date(Date.today.year)
    @last_year_species = Species.year_to_date(Date.today.year - 1)
  end

  def about
  end
  
  def page_kind
    "home"
  end
end
