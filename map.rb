require 'sinatra'
require 'rest_client'

helpers do
  def xmlDoc(url)
    xml = RestClient::Request.execute(:method => :get, :url => url, :timeout => 3)
    xml.body
  end

  def stopInfo
  	lines = File.readlines('stops.csv')
  	header = lines[0].split(',')
  	lines.shift

    nameIndex = header.index("name")
    latIndex = header.index("lat")
    lonIndex = header.index("lon")
    line1Index = header.index("line1")
    stop1Index = header.index("stop1")
    line2Index = header.index("line2")
    stop2Index = header.index("stop2")

  	stops = lines.collect do |s|
      puts s
	  	s = s.chomp.split(',')
      if s
  	  	{ :name => s[nameIndex],
  		  :lat => s[latIndex],
  		  :lon => s[lonIndex],
  		  :line1 => s[line1Index],
  		  :stop1 => s[stop1Index],
  		  :line2 => s[line2Index],
  		  :stop2 => s[stop2Index]
    		}
      else
        { :name => '',
        :lat => '',
        :lon => '',
        :line1 => '',
        :stop1 => '',
        :line2 => '',
        :stop2 => ''
        }
      end
	  end
  end
end

before do
	set :static, true
end

get '/' do
	@stops = stopInfo()
	erb :map2
end

get '/bikedata-dc' do
	xmlDoc('http://www.capitalbikeshare.com/stations/bikeStations.xml')
end

get '/bikedata-boston' do
	xmlDoc('http://www.thehubway.com/data/stations/bikeStations.xml')
end