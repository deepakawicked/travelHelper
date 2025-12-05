import g4p_controls.*;

TileMap streetMap;


boolean simulateMap = false;
String apiKey = ""; // MapTiler API key

// dragging
float xOffSet, yOffSet;
float dragStartX, dragStartY;
boolean dragging;

// slow scroll zoom
float zoomAccumulator = 0;
float zoomThreshold = 1.5;


//Calendar variables
ArrayList <Event> events = new ArrayList <Event>();
boolean showCalendar;
PImage calendarImg;
PFont font; 

void setup() {
  
  createGUI();
  size(800, 800);
  font = createFont("Times New Roman", 15);
  
  //calendar image
  imageMode(CENTER);
  calendarImg = loadImage("calendar.png");
  calendarImg.resize(250,0);
  
  // Example bounding box for Ontario + Quebec
  float minLat = 41.87, maxLat = 46.95;
  float minLon = -83.051, maxLon = -70.928;
  
  streetMap = new TileMap(minLat, maxLat, minLon, maxLon, 7, 6, 10);

  // center offsets at start
  float startLon = (minLon + maxLon) / 2;
  float startLat = (minLat + maxLat) / 2;
  float centerTileX = longToXTile(startLon, streetMap.currentZoom);
  float centerTileY = latToYTile(startLat, streetMap.currentZoom);
  xOffSet = width/2 - centerTileX * streetMap.tileSize;
  yOffSet = height/2 - centerTileY * streetMap.tileSize;
}

void draw() {
  background(255);
  
  // update visible tiles
  if (simulateMap) {
     streetMap.update(xOffSet, yOffSet);
     streetMap.drawTiles();
  }
  
  //Calendar code
  if (showCalendar){
    image(calendarImg, 150, 300);
    for (int i = 0; i < events.size(); i++){
      events.get(i).drawEvent();
    }
  }
  
  // center marker
  fill(255, 0, 0);
  circle(width/2, height/2, 30);
}
