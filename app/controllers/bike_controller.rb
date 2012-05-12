class BikeController < ApplicationController
  
  include ApplicationHelper

  def home
    @stops = stopInfo()
  end

  def about
  end

  def bikedata
    @stations = xmlDoc('http://www.thehubway.com/data/stations/bikeStations.xml')
    render :xml => @stations
  end
end
