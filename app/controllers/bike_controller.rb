class BikeController < ApplicationController
  
  include ApplicationHelper

  def home
    @stops = allSubwayStations()
  end

  def about
  end

  def bikedata
    @stations = xmlDoc('http://www.thehubway.com/data/stations/bikeStations.xml')
    render xml: @stations
  end

  def stopinfo
    line = params[:line]
    stop = params[:stop]
    if (line == '' || stop == '')
      render text: 'Bad request: missing stop or line', status: 400
      return
    end

    if (line != 'red' && line != 'blue' && line != 'orange')
      render text: 'Bad request: line must be red, blue or orange', status: 400
      return
    end

    # Capitalize the first letter of the line to get the file name
    file = line[0..0].upcase + line[1..-1] + '.txt'
    url = 'http://developer.mbta.com/Data/' + file

    begin
      trains = txtDoc(url)
    rescue RestClient::Request::Unauthorized
      status 403
      return 'Could not get train information'
    end

    system = {red: {direction1: 'Ashmont/Braintree', direction2: 'Alewife', compass1: 'S', compass2: 'N'},
      orange: {direction1: 'Forest Hills', direction2: 'Oak Grove', compass1: 'S', compass2: 'N'},
      blue: {direction1: 'Wonderland', direction2: 'Bowdoin', compass1: 'E', compass2: 'W'}}
    lineInfo = system[line.to_sym]

    @trains = { :direction1 => lineInfo[:direction1],
      :direction2 => lineInfo[:direction2],
      :times1 => predictedTrainTimes(trains, stop + lineInfo[:compass1]),
      :times2 => predictedTrainTimes(trains, stop + lineInfo[:compass2])
    }

    render json: @trains
  end
end
