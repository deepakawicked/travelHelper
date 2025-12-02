void mouseWheel(MouseEvent event) {
  //clamp to amount later
  float e = event.getCount();
  
  if (currentcurrentZoom > maxcurrentZoom) {
    currentcurrentZoom = maxZopm;
  } else if( currentcurrentZoom < mincurrentZoom) {
  
  }
  currentcurrentZoom = currentcurrentZoom - int(e);
  
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
