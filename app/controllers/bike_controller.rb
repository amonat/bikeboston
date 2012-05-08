class BikeController < ApplicationController
  
  include ApplicationHelper

  def home
    @stops = stopInfo()
  end

  def about
  end
end
