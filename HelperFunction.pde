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
    
    float mapL = longToXTile(streetMap.minLon, streetMap.currentZoom) * tileSize;
    float mapR = longToXTile(streetMap.maxLon, streetMap.currentZoom) * tileSize;
    float mapT = latToYTile(streetMap.maxLat, streetMap.currentZoom) * tileSize;
    float mapB = latToYTile(streetMap.minLat, streetMap.currentZoom) * tileSize;
    
    float mapW = mapR - mapL;
    float mapH = mapB - mapT;
    
    // Add padding so edges can reach screen edges
    float padX = width * 0.2;
    float padY = height * 0.2;
    
    if (mapW > width) {
      xOffSet = constrain(xOffSet, width - mapR - padX, -mapL + padX);
    }
    
    if (mapH > height) {
      yOffSet = constrain(yOffSet, height - mapB - padY, -mapT + padY);
    }
  }
}

void mouseReleased() {
  dragging = false;
}

void mouseWheel(MouseEvent event) {
  float mouseWorldX = (mouseX - xOffSet) / tileSize;
  float mouseWorldY = (mouseY - yOffSet) / tileSize;
  displayScale -= event.getCount() * zoomStep;
  // Clamp zoom 7 to max 1.1
  if (streetMap.currentZoom == 7) {
    displayScale = constrain(displayScale, 1.1, 2.0);
    } else {
    displayScale = constrain(displayScale, 0.5, 2.0);
  }
  
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
  
  float mapL = longToXTile(streetMap.minLon, streetMap.currentZoom) * tileSize;
  float mapR = longToXTile(streetMap.maxLon, streetMap.currentZoom) * tileSize;
  float mapT = latToYTile(streetMap.maxLat, streetMap.currentZoom) * tileSize;
  float mapB = latToYTile(streetMap.minLat, streetMap.currentZoom) * tileSize;
  
  float mapW = mapR - mapL;
  float mapH = mapB - mapT;
  
  float padX = width * 0.2;
  float padY = height * 0.2;
  
  if (mapW > width) {
    xOffSet = constrain(xOffSet, width - mapR - padX, -mapL + padX);
  }
  
  if (mapH > height) {
    yOffSet = constrain(yOffSet, height - mapB - padY, -mapT + padY);
  }
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
