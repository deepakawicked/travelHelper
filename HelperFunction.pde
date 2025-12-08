// ------------------------- MOUSE DRAG -------------------------

void mousePressed() {
  dragging = true;
  dragStartX = mouseX - xOffSet;
  dragStartY = mouseY - yOffSet;
  
  if (showCalendar){
    if (89 <= mouseX && mouseX <= 274){
      for (int i = 0; i < events.size(); i++){
        if ((37.48 + 30.88*(events.get(i).startTime-6)) <= mouseY && mouseY <= ((37.48 + 30.88*(events.get(i).startTime-6)) + events.get(i).duration*0.51467)){
          events.get(i).selected = true;
        }
        else events.get(i).selected = false;
        
      }
    }
  }
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
  
  float centerWorldX = (mouseX - xOffSet) / tileSize;
  float centerWorldY = (mouseY - yOffSet) / tileSize;
  float zoomScale;
  
  //update the scale with the mouse event
  displayScale -= event.getCount() * zoomStep; // turn into a progressive function later
  displayScale = constrain(displayScale, 0.5, 2.0);
    
  
  if (displayScale >= 2.0) {
    
    if (streetMap.currentZoom < streetMap.maxZoom) {
      zoomScale = 2.0;
      streetMap.currentZoom++;
      xOffSet = mouseX- centerWorldX * tileSize * zoomScale;
      yOffSet = mouseY - centerWorldY * tileSize * zoomScale;
      displayScale = 1.0;
      streetMap.tiles.clear();
    }
  
  } else if (displayScale <= 0.5) {
    
    if (streetMap.currentZoom > streetMap.minZoom) {
      streetMap.currentZoom--;
      zoomScale = 0.5;
      xOffSet = mouseX- centerWorldX * tileSize * zoomScale;
      yOffSet = mouseY - centerWorldY * tileSize * zoomScale;
      displayScale = 1.0;
      streetMap.tiles.clear();
  
    }
  }
  
  


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


float latLonToScreenX(float lon, int zoom) { //longtitude to screenX
  float tileX = longToXTile(lon, zoom);
  return tileX * tileSize + xOffSet;
}

float latLongtoScreenY(float lat, int zoom) { //latitude to screnY
  float tileY = latToYTile(lat, zoom);
  return tileY * tileSize + yOffSet;

}


//------------------------- CALENDAR FUNCTIONS --------------------
void createEvent(){
    String n = "name"; //attach to location/attraction classes after
    String st = startTimes.getSelectedText();
    int d = duration.getValueI();
    events.add(new Event(n,st,d));

  }
  
  
