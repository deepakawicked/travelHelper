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
  
  float e = event.getCount(); //+1 or -1
  streetMap.currentZoom = streetMap.currentZoom - int(e); 
  streetMap.currentZoom = constrain(streetMap.currentZoom, 7, 9); //clamp
  //the zoom to prevent too much tile requests 
  
  streetMap.tiles.clear();
  
  println("Current Zoom" + streetMap.currentZoom);
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
  
  
