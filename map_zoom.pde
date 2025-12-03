import g4p_controls.*;



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
  
  
  //convert to tiles 
  allowedXMin = floor(longToXTile(minLong));
  allowedXMax = ceil(longToXTile(maxLong));
  allowedYMin = floor(latToYTile(maxLat));
  allowedYMax = ceil(latToYTile(minLat));
}


void draw() { //<>//
  background(0);
  textSize(30);
  fill(255,0, 0);

  circle(width/2, height/2, 30);
   
}
