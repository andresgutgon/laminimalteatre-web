function getAddress (geocoder, coordinates, callback) {
  geocoder.geocode({'location': coordinates}, function(results, status) {
    if (status !== 'OK' || !results || !results[1]) {
      callback(null)
      return;
    }
    callback(results[1].formatted_address);
  });
}

function initMap() {
  if (!coordinates) return;
  var stylez = [
    {
      featureType: "all",
      elementType: "all",
      stylers: [
        { saturation: -100 } // <-- THIS
      ]
    }
  ];
  var noBussinesLayer = [{ featureType: 'poi', stylers: [ { visibility: 'off' } ] }];
  var map = new google.maps.Map(document.getElementById('js-map'), {
    zoom: 19,
    center: coordinates,
    styles: noBussinesLayer,
    mapTypeControlOptions: {
      mapTypeIds: [google.maps.MapTypeId.ROADMAP, 'tehgrayz']
    }
  });
  var mapType = new google.maps.StyledMapType(stylez, { name:"Grayscale" });
  map.mapTypes.set('tehgrayz', mapType);
  map.setMapTypeId('tehgrayz');

  var geocoder = new google.maps.Geocoder;
  getAddress(geocoder, coordinates, function (address) {
    var marker = new google.maps.Marker({
      map: map,
      position: coordinates,
      icon: '/assets/img/mapPin.png',
      animation: google.maps.Animation.DROP
    });

    if (address) {
      var infowindow = new google.maps.InfoWindow({
        content: address
      });
      infowindow.open(map, marker);
    }
  })

}
