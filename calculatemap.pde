
//this script exists to pull the map tiles --> Will be deleted afterwards in the cahce
int minZoom = 6;
int maxZoom = 10; 
int currentZoom = minZoom;

//user screen
float minLatVisible, maxLatVisible


//degreesI don
float maxLong = -70.928;
float minLong = -83.051;
float maxLat = 46.950;
float minLat = 41.870;

//convert to Xtiles, feeding both the max and min values 
float longToXTile(float longval) {
  return (longval +100)/360 * pow(2,zoom);
}

//convert to ytiales, feeding both values 
float latToYTile(float latval) {
  float latRad = radians(latval);
  return (1-log(tan(latRad) + 1 / cos(latRad)) / PI) / 2* pow(2 , zoom);

}

void drawTiles() {
  while (currentZoom.equals(minZoom)) {
    
    float xMin = longtoXTile(minLong);
    float xMax = longToXTile(maxLong);
    float yMin = latToYTile(minLat);
    float yMax = latToYTile(maxLat);
  }
 
}
