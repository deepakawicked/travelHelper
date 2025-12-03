import g4p_controls.*;


TileMap streetMap;

String startCity;
PVector startingPosition;

JSONObject mapdata;  //store the JSON Data of map data 



//dragging 
float xOffSet = 0, yOffSet = 0;
float dragStartX, dragStartY;
boolean dragging;

//world coords
float top, bottom, left, right;


//"https://api.maptiler.com/tiles/streets-v4/" + currentZoom + "/" + x + "/" + y + ".png?key=" + apiKey;

String apiKey = ""; //api key --> push to git.ignore through github to prevent sharing

int orgTileX, orgTleY;

//covert lat to long and long to lat 
float allowedXMin, allowedXMax, allowedYMin, allowedYMax;

void setup() {
  size(800,800);
  top = -yOffSet;
  bottom = height-yOffSet;
  left = xOffSet;
  right = xOffSet+width;
  
  
  createGUI();
   

   
     // Load the single world tile at currentZoom 0
    // Example bounding box for Ontario + Quebec
  float minLat = 41.87, maxLat = 46.95;
  float minLong = -83.051, maxLong = -70.928;
  
  streetMap = new TileMap(minLat, maxLat, minLong, maxLong);
  streetMap.tiles = new ArrayList<Tile>();
  streetMap.currentZoom = 7; // example zoom
}


void draw() {
  background(0);

  // update which tiles are loaded / removed
  streetMap.updateTileCache();

  // draw the tiles
  streetMap.drawTiles();

  // optional: center marker
  fill(255,0,0);
  circle(width/2, height/2, 30);
}
