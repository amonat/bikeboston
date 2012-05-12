require 'spec_helper'

describe BikeController do

  describe "GET bikedata XML resource" do

    it "gets a stations object" do
      get :bikedata
      assigns(:stations).should_not be_empty
    end
  end

end
