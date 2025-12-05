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

// ------------------------- TILE FUNCTIONS -------------------------
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
  
  
