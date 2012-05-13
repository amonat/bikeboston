# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
setFullSizeIfPhone = ->
  $("#map_canvas").width('100%').height('90%')

trainTimesString = (times) ->
  result = ''
  for i in [0...times.length]
    result += times[i]
    if (i < times.length - 1)
      result += ", "
  if (times.length == 0)
    result += "No trains"
  result

makeStopInfo = (s, result1, result2) ->
  data1 = result1[0]
  data2 = if result2 then result2[0] else null
  $v = $("<div>").append("<strong>" + s.name)
  $v.append("<div><em>" + data1.direction1 + ": " + trainTimesString(data1.times1))
  $v.append("<div><em>" + data1.direction2 + ": " + trainTimesString(data1.times2))
  if (data2)
    $v.append("<div><em>" + data2.direction1 + ": " + trainTimesString(data2.times1))
    $v.append("<div><em>" + data2.direction2 + ": " + trainTimesString(data2.times2))
  $v.html()

# A collection of all the markers on the screen
markers = []

showMarkers = (map) ->
  bounds = map.getBounds()
  if (!bounds)
    return
  for i in [0...markers.length]
    visible = bounds.contains(markers[i].getPosition())
    desiredMap = if visible then map else null
    if (desiredMap != markers[i].getMap())
      markers[i].setMap(desiredMap)

showInfoBox = ->
  $("#infoboxcontent").show('fast')

hideInfoBox = ->
  $("#infoboxcontent").hide('fast')

setInfoBoxContent = (content) ->
  $("#infoboxcontent").html(content)

$(->
  setFullSizeIfPhone()
  myOptions = {
    center: new google.maps.LatLng(42.35639457,-71.0624242),
    zoom: 15,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map(document.getElementById("map_canvas"),
      myOptions)
  google.maps.event.addListener(map, 'idle', ->
    showMarkers(map)
  )

  request = null

  if (navigator && navigator.geolocation)
    success = (position) ->
      userLatLng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
      map.setCenter(userLatLng)
    navigator.geolocation.getCurrentPosition(success)

  $.each(stops, (i, s) ->
    latLng = new google.maps.LatLng(s.lat, s.lon)
    marker = new google.maps.Marker({
      position: latLng,
      map: null,
      title: s.name,
      icon: '/assets/mbta-pin.png'
    })
    markers.push(marker)

    google.maps.event.addListener(marker, 'click', ->
      content = "<div><strong>" + s.name + "</div></strong>"
      if (s.line1 && s.stop1)
        content += "Loading..."
      setInfoBoxContent(content)
      showInfoBox()

      if (s.line1 && s.stop1)
        request1 = $.getJSON('/stopinfo?line=' + s.line1 + '&stop=' + s.stop1)
        request2 = if (s.line2 && s.stop2) then $.getJSON('/stopinfo?line=' + s.line2 + '&stop=' + s.stop2) else $.Deferred().resolve()
        $.when(request1, request2).then((result1, result2) ->
            setInfoBoxContent(makeStopInfo(s, result1, result2))
        )
    )

  )

  $.get('/bikedata').done((data) ->
    $(data).find('station').each((i, station) ->
        $station = $(station)
        name = $station.children('name').text()
        lat = $station.children('lat').text()
        lng = $station.children('long').text()
        numBikes = $station.children('nbbikes').text()
        numEmpty = $station.children('nbemptydocks').text()
        latLng = new google.maps.LatLng(lat, lng)
        icon = if (Number(numBikes) > 0) then '/assets/bike.png' else '/assets/bike-red.png'

        marker = new google.maps.Marker({
          position: latLng,
          map: null,
          title: name,
          icon: icon
        })
        markers.push(marker)

        google.maps.event.addListener(marker, 'click', ->
          setInfoBoxContent("<strong>" + name + "</strong><div><em>" + numBikes + " bikes</em></div><div><em>" + numEmpty + " empty docks</em></div>")
          showInfoBox()
        )
    )

    showMarkers(map)
  )

)
