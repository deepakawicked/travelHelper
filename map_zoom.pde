JSONObject mapdata;  //store the JSON Data of map data 
float xOffSet = 0, yOffSet = 0;
float dragStartX, dragStartY;
boolean dragging;
int zoom = 0; //determines the asked zoom levels
PImage tile;
int tileSize = 256; 


//"https://api.maptiler.com/tiles/streets-v4/" + zoom + "/" + x + "/" + y + ".png?key=" + apiKey;
String tilesetID = "tiles/abc123xyz"; //style of the map, 
String apiKey = "LldPKtMY773CoUBEot4H"; //api key --> push to git.ignore through github to prevent sharing

int orgTileX, orgTleY;

//covert lat to long and long to lat 

void setup() {
   size(800,800);
     // Load the single world tile at zoom 0
  String url = "https://api.maptiler.com/maps/streets-v4/256/2/1/2.png?key=" + apiKey;

  tile = loadImage(url);


}


void draw() { //<>//
  background(0);
  if (tile != null) {
    image(tile, 0, 0, 800, 800);
  }
  

  translate(xOffSet, yOffSet);
  circle(width/2, height/2, 30);
  
}
