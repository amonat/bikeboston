require 'spec_helper'

describe BikeController do

  describe "GET bikedata XML resource" do

    it "assigns a @stations variable" do
      get :bikedata
      assigns(:stations).should_not be_empty
    end
  end

  describe "GET stopinfo JSON resource" do

    it "assigns a @trains variable" do
      get :stopinfo
      assigns(:trains).should_not be_empty
    end
  end

end
