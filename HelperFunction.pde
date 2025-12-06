// ------------------------- MOUSE DRAG -------------------------

void mousePressed() {
  dragging = true;
  dragStartX = mouseX - xOffSet;
  dragStartY = mouseY - yOffSet;
}

void mouseDragged() {
  if (dragging) {
    xOffSet = mouseX - dragStartX;
    yOffSet = mouseY - dragStartY;
  }
}

void mouseReleased() {
  dragging = false;
}


//detects the mouse press
void mouseWheel(MouseEvent event) {

  //️Store the old zoom
  int oldZoom = streetMap.currentZoom;

  //  Compute the world coordinates of the screen center (marker) in tile units
  float centerWorldX = (width/2 - xOffSet) / tileSize;
  float centerWorldY = (height/2 - yOffSet) / tileSize;

  // Update zoom level
  streetMap.currentZoom = constrain(streetMap.currentZoom - int(event.getCount()), 7, 9);
  int newZoom = streetMap.currentZoom;

  // Compute zoom scale factor (tiles double per zoom level)
  float zoomScale = pow(2, newZoom - oldZoom);

  // Recalculate offsets so the centerWorld point stays under the screen center
  xOffSet = width/2 - centerWorldX * tileSize * zoomScale;
  yOffSet = height/2 - centerWorldY * tileSize * zoomScale;

  // 6️⃣ Clear old tiles and request new ones for the new zoom
  streetMap.tiles.clear();
  streetMap.update(xOffSet, yOffSet);

  println("Zoom changed from " + oldZoom + " to " + newZoom);
}



// ------------------------- TILE FUNCTIONS -------------------------

//covert from the latitude/longitude grid of the real world to the tile System
//most commonly found in google maps and API's (Maptiler, etc);
float longToXTile(float longval, int zoom) {

  return (longval + 180) / 360 * pow(2, zoom);
}

float latToYTile(float latval, int zoom) {
  float latRad = radians(latval);
  return (1 - (log(tan(latRad) + 1 / cos(latRad)) / PI)) / 2 * pow(2, zoom);
}

//------------------------- CALENDAR FUNCTIONS --------------------
void createEvent(){
    String n = "name"; //attach to location/attraction classes after
    String st = startTimes.getSelectedText();
    int d = duration.getValueI();
    events.add(new Event(n,st,d));

  }
  
  
