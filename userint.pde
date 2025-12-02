void mouseWheel(MouseEvent event) {
  //clamp to amount later
  float e = event.getCount();
  currentZoom = constrain(currentZoom, 7, 9);
  currentZoom = currentZoom - int(e);
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
