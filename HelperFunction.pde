// ---- Panning and zoom functions ----
void mousePressed() {
  dragging = true;
  dragStartX = mouseX - xOffSet;
  dragStartY = mouseY - yOffSet;

  if (showCalendar){
    if (89 <= mouseX && mouseX <= 274){
      for (int i = 0; i < events.size(); i++){
        float top = 37.48 + 30.88 * (events.get(i).startTime - 6);
        float bottom = top + events.get(i).duration * 0.51467;
        events.get(i).selected = (top <= mouseY && mouseY <= bottom);
      }
    }
  }
}

void mouseDragged() {
  if (dragging) {
    xOffSet = mouseX - dragStartX;
    yOffSet = mouseY - dragStartY;

    // Clamp panning to prevent moving beyond map bounds
    float minX = -longToXTile(streetMap.minLon, streetMap.currentZoom) * tileSize;
    float maxX = width - longToXTile(streetMap.maxLon, streetMap.currentZoom) * tileSize;
    float minY = -latToYTile(streetMap.maxLat, streetMap.currentZoom) * tileSize;
    float maxY = height - latToYTile(streetMap.minLat, streetMap.currentZoom) * tileSize;

    xOffSet = constrain(xOffSet, maxX, minX);
    yOffSet = constrain(yOffSet, maxY, minY);
  }
}

void mouseReleased() {
  dragging = false;
}

void mouseWheel(MouseEvent event) {
  float mouseWorldX = (mouseX - xOffSet) / tileSize;
  float mouseWorldY = (mouseY - yOffSet) / tileSize;

  displayScale -= event.getCount() * zoomStep;
  displayScale = constrain(displayScale, 0.5, 2.0);

  if (displayScale >= 2.0 && streetMap.currentZoom < streetMap.maxZoom) {
    streetMap.currentZoom++;
    adjustOffsetAfterZoom(mouseX, mouseY, mouseWorldX, mouseWorldY, 2.0);
  } else if (displayScale <= 0.5 && streetMap.currentZoom > streetMap.minZoom) {
    streetMap.currentZoom--;
    adjustOffsetAfterZoom(mouseX, mouseY, mouseWorldX, mouseWorldY, 0.5);
  }
}

void adjustOffsetAfterZoom(float mouseX, float mouseY, float worldX, float worldY, float zoomScale) {
  xOffSet = mouseX - worldX * tileSize * zoomScale;
  yOffSet = mouseY - worldY * tileSize * zoomScale;

  displayScale = 1.0;
  streetMap.tiles.clear();

  // Clamp offsets after zoom
  float minX = -longToXTile(streetMap.minLon, streetMap.currentZoom) * tileSize;
  float maxX = width - longToXTile(streetMap.maxLon, streetMap.currentZoom) * tileSize;
  float minY = -latToYTile(streetMap.maxLat, streetMap.currentZoom) * tileSize;
  float maxY = height - latToYTile(streetMap.minLat, streetMap.currentZoom) * tileSize;

  xOffSet = constrain(xOffSet, maxX, minX);
  yOffSet = constrain(yOffSet, maxY, minY);
}

// ---- Tile conversion ----
float longToXTile(float longval, int zoom) {
  return (longval + 180) / 360 * pow(2, zoom);
}

float latToYTile(float latval, int zoom) {
  float latRad = radians(latval);
  return (1 - (log(tan(latRad) + 1 / cos(latRad)) / PI)) / 2 * pow(2, zoom);
}

float latLonToScreenX(float lon, int zoom) {
  float tileX = longToXTile(lon, zoom);
  return tileX * tileSize + xOffSet;
}

float latLontoScreenY(float lat, int zoom) {
  float tileY = latToYTile(lat, zoom);
  return tileY * tileSize + yOffSet;
}


void createEvent() {
  String n = "name";
  String st = startTimes.getSelectedText();
  int d = duration.getValueI();
  events.add(new Event(n, st, d));
}
