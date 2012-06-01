class SubwayStation < ActiveRecord::Base
  attr_accessible :lat, :lon, :name

  has_many :subway_stops
end
