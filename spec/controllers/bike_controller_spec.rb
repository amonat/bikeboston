require 'spec_helper'

describe BikeController do

  describe "GET bikedata XML resource" do

    it "assigns a @stations variable" do
      responseBody =
        """
        <?xml version='1.0' encoding='UTF-8'?>
        <stations lastUpdate='1336854314155' version='2.0'>
          <station>
            <id>3</id>
            <name>Colleges of the Fenway</name>
            <terminalName>B32006</terminalName>
            <lat>42.340021</lat>
            <long>-71.100812</long>
            <installed>true</installed>
            <locked>false</locked>
            <installDate/>
            <removalDate/>
            <temporary>false</temporary>
            <nbBikes>1</nbBikes>
            <nbEmptyDocks>14</nbEmptyDocks>
            <latestUpdateTime>1336853983619</latestUpdateTime>
          </station>
        </stations>
        """

      stub_request(:get, "http://www.thehubway.com/data/stations/bikeStations.xml").
         to_return(:status => 200, :body => responseBody)

      get :bikedata
      assigns(:stations).should_not be_empty
    end
  end

  describe "GET stopinfo JSON resource" do

    it "assigns a @trains variable" do
      redLineUrl = 'http://developer.mbta.com/Data/Red.txt'
      stub_request(:get, redLineUrl).
          to_return(:body => 'Red, 579, RDAVN, Predicted, 5/12/2012 4:08:46 PM, 00:01:56, Revenue, 0')

      get :stopinfo, line: 'red', stop: 'RDAV'
      assigns(:trains).should_not be_empty
      assigns(:trains)[:direction1].should eq('Ashmont/Braintree')
      assigns(:trains)[:direction2].should eq('Alewife')
      assigns(:trains)[:times1].should be_empty
      assigns(:trains)[:times2].should eq(["1 min."])

      stub_request(:get, redLineUrl).with().should have_been_made.once
    end
  end

end
