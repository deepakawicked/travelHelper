void mouseWheel(MouseEvent event) {
  //clamp to amount later
  float e = event.getCount();
  
  if (currentZoom > maxZoom) {
    currentZoom = maxZopm;
  } else if( currentZoom < minZoom) {
  
  }
  currentZoom = currentZoom - int(e);
  
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
