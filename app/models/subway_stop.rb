class SubwayStop < ActiveRecord::Base
  attr_accessible :code, :subway_station, :subway_line

  belongs_to :subway_station
  belongs_to :subway_line
end
