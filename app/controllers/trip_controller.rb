class TripController < ApplicationController
  scaffold :trip
  layout "standard"
  
  def list
    @trips = Trip.find(:all, :order => "ignored DESC")
    @page_title = "Trips"
  end
  
  def show
    @trip = Trip.find(params["id"])
    @page_title = @trip.name
  end
end
