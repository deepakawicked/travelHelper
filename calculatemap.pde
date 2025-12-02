//loading: world cooders --> mercator projecitons --> x,y processng oswa

//when requesting: 
//this script exists to pull the map tiles
int minZoom = 6;
int maxZoom = 10; 
int currentZoom = minZoom;
boolean zooming = true;;


//max bounding box. Processing will not request outside of  these tiles in maptiler 

//degrees bounding box. Limiting to Ontario and Quebec --> Move into a docuemnt later 
float maxLong = -70.928;
float minLong = -83.051;
float maxLat = 46.950;
float minLat = 41.870;


float xMin = floor(longToXTile(minLong));
float xMax = ceil(longToXTile(maxLong));
float yMin = floor(latToYTile(minLat));
float yMax = ceil(latToYTile(maxLat));
    

//user screen --> Only draw the tiles needed for these 
float minLatVisible

maxLatVisible, minLongVisble, minMaxVisible;




//convert to Xtiles, feeding both the max and min values 
float longToXTile(float longval) {
  return (longval +180)/360 * pow(2, currentZoom);
}

//convert to ytiales, feeding both values 
float latToYTile(float latval) {
  float latRad = radians(latval);
  return (1-log(tan(latRad) + 1 / cos(latRad)) / PI) / 2* pow(2 , zoom);

}

float tileToWorldX(int tileX) {// convet to world X
  return tileX * pow(2, zoom);
}

float tileToWorldY(int tileY) { //convert to world Y
  return tileY * pow(2, zoom);
}

float bounding 
void getTile(int x, int y, int zoom) {} //request tiles from mapTiler or other backup options 
void drawTiles() {
  float mapSize = 256 * pow(2, zoom); //convert the visable amount of pixles 
  worldX = x*
  while (zooming) {
    //bounding box 
    xMinVisible = floor(longToXTile(minLongVisible));
    xMaxVisible = ceil(longToXTile(maxLongVisible)) - 1;
    yMinVisible = floor(latToYTile(maxLatVisible));
    yMaxVisible = ceil(latToYTile(minLatVisible)) - 1;
    
    if (xMinVisible > 
  }
 
}
