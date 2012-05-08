module ApplicationHelper
  def xmlDoc(url)
    xml = RestClient::Request.execute(:method => :get, :url => url, :timeout => 3)
    xml.body
  end

  def txtDoc(url)
    RestClient::Request.execute(:method => :get, :url => url, :timeout => 3).body.split("\r\n")
  end

  @@timeRegexp = /(-?)(\d\d):(\d\d):(\d\d)/

  # Get the time in seconds from a string like hh:mm:ss.
  def getTimeSeconds(timeStr)
    m = @@timeRegexp.match(timeStr)
    m ? (m[1].empty? ? 1 : -1) * ((m[2].to_i * 60 * 60) + (m[3].to_i * 60) + m[4].to_i) : 0
  end

  # Get the time in minutes from a string like hh:mm:ss, rounded up to the nearest minute.
  def getTimeMinutes(timeStr)
    m = @@timeRegexp.match(timeStr)
    m ? (m[1].empty? ? 1 : -1) * ((m[2].to_i * 60) + (m[3].to_i)) : 0
  end

  # Get the time in minutes from a string like hh:mm:ss, rounded up to the nearest minute
  # and turned into a friendly string.
  def getMinutesString(timeStr)
    minutes = getTimeMinutes(timeStr)
    minutes < 1 ? "Arriving" : minutes.to_s + " min."
  end

  def getMinutesStringFromSeconds(seconds)
    minutes = seconds / 60
    minutes < 1 ? "Arriving" : minutes.to_s + " min."
  end

  # Get the predicted train times for a platform given the list of trains for a route.
  def predictedTrainTimes(trains, platform, route0Desc="", route1Desc="")
    predictedItems = trains.find_all do |t|
      t.index("Predicted") && t.index(platform)
    end
    predictedItems.sort! do |x, y|
      xSecs = getTimeSeconds(x.split(",")[5])
      ySecs = getTimeSeconds(y.split(",")[5])
      xSecs <=> ySecs
    end
    predictedItems.collect do |e|
      time = e.split(",")[5]
      route = e.split(",")[7].to_i
      routeDesc = route0Desc.empty? ? "" : " (" + (route == 0 ? route0Desc : route1Desc) + ")"
      getMinutesString(time) + routeDesc
    end
  end

  def stopInfo
    lines = File.open("#{Rails.root}/app/datafiles/stops.csv").readlines
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
