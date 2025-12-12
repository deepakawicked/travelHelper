attractions selected;

// ---- Panning and zoom functions ----
void mousePressed() {
  dragging = true; //set the draging to true, allow the create the movement of tiles 
  dragStartX = mouseX - xOffSet; //add respective mouse pos with the offset
  dragStartY = mouseY - yOffSet;
  
  //check if clicking on calendar events
  if (showCalendar){
    if (89 <= mouseX && mouseX <= 274){
      for (int i = 0; i < events.size(); i++){
        float top = 37.48 + 30.88 * (events.get(i).startTime - 6);
        float bottom = top + events.get(i).duration * 0.51467;
        events.get(i).selected = (top <= mouseY && mouseY <= bottom);
      }
    }
  }
  
  boolean clickedAttraction = false; //track if an attraction was clicked
  
  //Transform mouse coords to match the scaled map coordinates
  float scaledMouseX = (mouseX - width/2) / displayScale + width/2;
  float scaledMouseY = (mouseY - height/2) / displayScale + height/2;
  
  //check if clicking on any attractions with scaled hitbox
  for (int i = 0; i < attractionList.size(); i++){
    attractions a = attractionList.get(i);
    float hitboxSize = 30 / displayScale; //scale hitbox with zoom
    
    if ((a.x - hitboxSize <= scaledMouseX && scaledMouseX <= a.x + hitboxSize) &&
        (a.y - hitboxSize <= scaledMouseY && scaledMouseY <= a.y + hitboxSize)){
      boolean in = viable.contains(a);
      if (in) {
        selected = a;
        clickedAttraction = true;
      }
    }
  }
  
  //Create event box - check if clicking "Create Event" button
  if (selected != null && (selected.x+60 <= mouseX && mouseX <= selected.x+140)&&
      (selected.y + 45 <= mouseY && mouseY <= selected.y + 75)){
    eventswin.setVisible(true);
  }
  
  // Deselect attraction if clicked elsewhere (not on attraction or info box)
  if (!clickedAttraction && selected != null) {
    // Check if NOT clicking the info box
    if (!(selected.x <= mouseX && mouseX <= selected.x+150 && 
          selected.y <= mouseY && mouseY <= selected.y+80)) {
      selected = null; //clear selection
    }
  }
}

void mouseDragged() {
  if (dragging) { //only calculate when bounding 
    xOffSet = mouseX - dragStartX; //allowing for movement of the tiles, constantly updating the position through the Tile Class 
    yOffSet = mouseY - dragStartY;
    
    
    //calculate the bounding box of how much the user is allowed to move on screen 
    //Covert to min/max longitude/latitude into tile coodernates, and mutiply by tileSize to get the exact pixel positons 
    float mapL = longToXTile(streetMap.minLon, streetMap.currentZoom) * tileSize;
    float mapR = longToXTile(streetMap.maxLon, streetMap.currentZoom) * tileSize;
    float mapT = latToYTile(streetMap.maxLat, streetMap.currentZoom) * tileSize;
    float mapB = latToYTile(streetMap.minLat, streetMap.currentZoom) * tileSize;
    
    //calculate the total width/height of the map in mixels 
    float mapW = mapR - mapL;
    float mapH = mapB - mapT;
    
    // Add padding so edges can reach screen edges. Prevents the map from instantly snapping back when reaching screen edge 
    float padX = width * 0.2; //20% padding both horizontally and vertically 
    float padY = height * 0.2;
    
    //only contrast if the map is larger than the screen 
    if (mapW > width) {
      xOffSet = constrain(xOffSet, width - mapR - padX, -mapL + padX); //left bound, to right bound 
    }
    
    if (mapH > height) { //only contrain if the map render is taller than the screen, preventing far too up or past edges 
      yOffSet = constrain(yOffSet, height - mapB - padY, -mapT + padY);
    }
  }
}

void mouseReleased() {
  dragging = false; //turn off all the offset movement 
}

void mouseWheel(MouseEvent event) {
  
  //mouse postion in world/tile space (needed to anchor the zoom to the cusors)
  float mouseWorldX = (mouseX - xOffSet) / tileSize;
  float mouseWorldY = (mouseY - yOffSet) / tileSize;
  
  
  //apply wheel input to scale (scroll up = zoom in, scroll down = zoom down)
  displayScale -= event.getCount() * zoomStep;
  
  
  //clamp the scale (7 is special as there is no bigger map then zoom 7, there clamping zoom 7 prevents the zoom
  //from going too out on 7
  if (streetMap.currentZoom == 7) {
    displayScale = constrain(displayScale, 1.1, 2.0);
    } else {
    displayScale = constrain(displayScale, 0.5, 2.0); //for every other zoom, allows from 1/2x to 2x zoom
  }
  
  //when the scale hit limits, switch the actual map zoom level (the tiles found in memory)
  //adjustOffset() keeps the poitns under the cursor alligned (so there is not a big jump)
  
  if (displayScale >= 2.0 && streetMap.currentZoom < streetMap.maxZoom) { 
    streetMap.currentZoom++; //if the user zoomes in too much, scale down 
    adjustOffsetAfterZoom(mouseWorldX, mouseWorldY, 2.0);
  } else if (displayScale <= 0.5 && streetMap.currentZoom > streetMap.minZoom) {
    streetMap.currentZoom--; //if the user zooms out, scale up 
    adjustOffsetAfterZoom( mouseWorldX, mouseWorldY, 0.5);
  }
}

void adjustOffsetAfterZoom(float worldX, float worldY, float zoomScale) {
  
  //respostion so the map under the cursor stays fixed after the zoom change (so there is not zoom much fmumping)
  xOffSet = mouseX - worldX * tileSize * zoomScale;
  yOffSet = mouseY - worldY * tileSize * zoomScale;
  
  //reset temperorsy scale; the zoom level has changed and thereform the zoom can be apply for the new zoom level
  displayScale = 1.0;
  
  //force tiles to be generated for the new zoom level
  streetMap.tiles.clear();
  

}

// ---- Tile conversion ----
//This program convert from 3 different coodernate system. The Processing World Coodernate, the Slippy Tile Mercator Projection (used for calling tiles and 
//how MapTileAPI is stored and used, and real world Coodernates (lat, long)

//convert to longitude to tileX index at a given zoom level
float longToXTile(float longval, int zoom) {
  return (longval + 180) / 360 * pow(2, zoom);
}

//convert latitude to tile Y using Web Mercator projections 
float latToYTile(float latval, int zoom) {
  float latRad = radians(latval);
  return (1 - (log(tan(latRad) + 1 / cos(latRad)) / PI)) / 2 * pow(2, zoom);
}


//convert lon directly to on screen coords (x) (tiles and the offset factor in as well)
float latLonToScreenX(float lon, int zoom) {
  float tileX = longToXTile(lon, zoom);
  return tileX * tileSize + xOffSet;
}

//convert lat directly to on screen coords (y) (tiles and the offset factor in as well)
float latLontoScreenY(float lat, int zoom) {
  float tileY = latToYTile(lat, zoom);
  return tileY * tileSize + yOffSet;
}

//create a new event from the UI selections and push to event lit 
void createEvent(attractions a){
  String n = a.name;
  String st = startTimes.getSelectedText();
  int d = duration.getValueI();
  events.add(new Event(n, st, d));
}
