float longToXTile(float longval. TileMap t) {
  return (longval +180)/360 * pow(2, t.currentZoom);
}

//convert to ytiales, feeding both values 
float latToYTile(float latval, TileMap t) {
  float latRad = radians(latval);
  return (1 - (log(tan(latRad) + 1 / cos(latRad)) / PI)) / 2 * pow(2, t.currentZoom);
}

float tileToWorldX(int tileX) {// convet to world X
  return tileX * tileSize;
}

float tileToWorldY(int tileY) { //convert to world Y
  return tileY * tileSize;
}




//-----------------------------USER INPUTS----------------------------------------------------|


void mouseWheel(MouseEvent event) {
  //clamp to amount later
  float e = event.getCount();
  currentZoom = currentZoom - int(e);
  currentZoom = constrain(currentZoom, 7, 9);
 
  println("Current Zoom" + currentZoom);
  
  
}


void mousePressed() {

  dragging = true;
  dragStartX = mouseX - xOffSet;
  dragStartY = mouseY - yOffSet;
  

}
void mouseDragged() {

  
  xOffSet = mouseX - dragStartX;
  yOffSet = mouseY- dragStartY;
  
}


void mouseReleased() {
  dragging = false;
}
