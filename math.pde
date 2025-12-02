float longToXTile(float longval) {
  return (longval +180)/360 * pow(2, currentZoom);
}

//convert to ytiales, feeding both values 
float latToYTile(float latval) {
  float latRad = radians(latval);
  return (1 - (log(tan(latRad) + 1 / cos(latRad)) / PI)) / 2 * pow(2, currentZoom);
}

float tileToWorldX(int tileX) {// convet to world X
  return tileX * tileSize;
}

float tileToWorldY(int tileY) { //convert to world Y
  return tileY * tileSize;
}
