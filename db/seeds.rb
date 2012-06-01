# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Subway lines with available data
SubwayLine.delete_all
SubwayLine.create(name: 'Red')
SubwayLine.create(name: 'Orange')
SubwayLine.create(name: 'Blue')

# Subway stations and stops
SubwayStation.delete_all
SubwayStop.delete_all

indexes = nil

def addStop(subway_station, line, stop)
  if line && stop
    line = line.slice(0,1).capitalize + line.slice(1..-1)
    subway_line = SubwayLine.find_by_name(line)
    #puts subway_line, subway_line.id
    SubwayStop.create(
        code: stop,
        subway_station: subway_station,
        subway_line: subway_line
      )
  end
end

open("app/datafiles/stops.csv") do |stations|
  stations.read.each_line do |station|
    fields = station.strip.split(',')
    if !indexes
      # the first line is the header, which you can get indexes from
      indexes = {
        nameIndex: fields.index("name"),
        latIndex: fields.index("lat"),
        lonIndex: fields.index("lon"),
        line1Index: fields.index("line1"),
        stop1Index: fields.index("stop1"),
        line2Index: fields.index("line2"),
        stop2Index: fields.index("stop2")
      }
      #puts indexes
    else
      subway_station = SubwayStation.create(
        name: fields[indexes[:nameIndex]],
        lat: fields[indexes[:latIndex]],
        lon: fields[indexes[:lonIndex]])
      #puts subway_station.name, subway_station.lat, subway_station.lon

      addStop(subway_station, fields[indexes[:line1Index]], fields[indexes[:stop1Index]])
      addStop(subway_station, fields[indexes[:line2Index]], fields[indexes[:stop2Index]])
    end
  end
end
