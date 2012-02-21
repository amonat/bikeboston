require 'sinatra'
require 'rest_client'

helpers do
  def xmlDoc(url)
    xml = RestClient::Request.execute(:method => :get, :url => url, :timeout => 3)
    xml.body
  end
end

before do
	set :static, true
end

get '/' do
	erb :map2
end

get '/bikedata' do
	xmlDoc('www.capitalbikeshare.com/stations/bikeStations.xml')
end