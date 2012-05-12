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

  def stopinfo
    @trains = ['train']
    render :json => @trains
  end
end
