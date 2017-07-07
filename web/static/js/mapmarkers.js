function putMarkerOnMap(JSONMarker, markerIcon, googleMap, mapID) {
  let markerPosition = { lat: parseFloat(JSONMarker.lat),
                          lng: parseFloat(JSONMarker.long)
                       };

  let infowindow = new google.maps.InfoWindow();
  let googleMarker = new google.maps.Marker({
                        icon: markerIcon,
                        draggable: DRAGGABLE,
                        map: googleMap,
                        position: markerPosition,
                        scaledSize: new google.maps.Size(30, 30),
                        anchor: new google.maps.Point(20,40)
                      });

    google.maps.event.addListener(googleMarker, 'click',
        () => {openInfoWindow(JSONMarker, infowindow)});

    google.maps.event.addListener(googleMarker, 'dragend',
        (e) => {saveMarker(e, JSONMarker, mapID)});

  function saveMarker(e, JSONMarker, mapID) {
                  JSONMarker.lat = e.latLng.lat()+"";
                  JSONMarker.long = e.latLng.lng()+"";
                  let jsonRequestData= { marker: JSONMarker };
                  jsonRequest("PATCH",
                             "/api/map/"+mapID+"/markers/"+JSONMarker.id,
                             jsonRequestData);
  }

  function openInfoWindow(JSONMarker, infowindow) {
        infowindow.setContent(infoWindowContent(JSONMarker.img_URL,
                                                JSONMarker.name,
                                                JSONMarker.text));
        infowindow.open(googleMap, googleMarker);
  }

  function infoWindowContent(imgURL,name,text) {
    return `<div class="infowindow-content">
              <div class="infowindow-content__image">
                <img src="${imgURL}">
               </div>
               <div class="infowindow-content__text">
                 <h3 class="infowindow-content__heading">
                   ${name}
                 </h3>
                <p class="infowindow-content__text">
                  ${text}
                </p>
              </div>
            </div>`;
  }
}
export default  putMarkerOnMap
