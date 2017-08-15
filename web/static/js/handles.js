function putHandlesOnMap({enhancedMap, mapOverlay, mapId, overlay_north, overlay_south, overlay_west, overlay_east}) {
    /* handles for adjusting the overlay */
  let handleIcon = {
    url: "https://upload.wikimedia.org/wikipedia/commons/d/d1/Square.png",
    scaledSize: new google.maps.Size(10, 10),
  }

  let topLeftHandle = new google.maps.Marker({
                      icon: handleIcon,
                      draggable: true,
                      map: enhancedMap,
                      position: {lat: overlay_north,
                                lng: overlay_west
                      }
                });
 
  let bottomRightHandle = new google.maps.Marker({
                      icon: handleIcon,
                      draggable: true,
                      map: enhancedMap,
                      position: {lat: overlay_south,
                                lng: overlay_east
                      }
                });

  function updateOverlayBounds() {
    let newTopLeft = topLeftHandle.getPosition();
    let newBottomRight = bottomRightHandle.getPosition();
    let newBounds = new google.maps.LatLngBounds();

    /* switch from nw,se handles to ne,sw bounding box */
    newBounds.extend(newTopLeft);
    newBounds.extend(newBottomRight);
    mapOverlay.set("bounds", newBounds);

    mapOverlay.setMap(enhancedMap);
  }


  google.maps.event.addListener(topLeftHandle,'drag',updateOverlayBounds);
  google.maps.event.addListener(bottomRightHandle,'drag',updateOverlayBounds);

  google.maps.event.addListener(topLeftHandle, 'dragend', updateMap(mapId));
  google.maps.event.addListener(bottomRightHandle, 'dragend', updateMap(mapId));
  function updateMap(mapId) {
    return function() {
      let newTopLeft = topLeftHandle.getPosition();
      let newBottomRight = bottomRightHandle.getPosition();
      let jsonRequestData = 
        {map: 
          {
            overlay_north: newTopLeft.lat()+"",
            overlay_west: newTopLeft.lng()+"",
            overlay_south: newBottomRight.lat()+"",
            overlay_east: newBottomRight.lng()+""
          }
        };

      jsonRequest("PATCH","/api/map/"+mapId,jsonRequestData);
    }
  }
}
export default putHandlesOnMap
