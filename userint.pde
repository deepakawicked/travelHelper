void mouseWheel(MouseEvent event) {
  //clamp to amount later
  float e = event.getCount();
  zoom = zoom - int(e);
  println(zoom);
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
