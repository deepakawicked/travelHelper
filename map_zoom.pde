import g4p_controls.*;

TileMap streetMap;

//fill these if needed to found
boolean simulateMap = true;
String apiKey = ""; // MapTiler API key, not included in push

// dragging
float xOffSet, yOffSet;
float dragStartX, dragStartY;
boolean dragging;

// slow scroll zoom
float displayScale = 1.0;
float zoomStep = 0.1;
float tileSize = 256;
 


//Calendar variables
ArrayList <Event> events = new ArrayList <Event>();
boolean showCalendar;
PImage calendarImg, logo, bg, cityMarker, attractionMarker;
PFont font; 
float routeDistance;  
float routeDuration; 
City startCity, endCity;
Boolean drawRoad = false;
ArrayList<Location> roadPoints;


void setup() {
  
  createGUI();
  size(800, 800);
  font = createFont("Times New Roman", 15);
  
  //calendar image
  imageMode(CENTER);
  calendarImg = loadImage("calendar.png");
  calendarImg.resize(250,0);
 
  logo = loadImage("journeylog.png");
  bg = loadImage("background.png");
  
  // Example bounding box for Ontario + Quebec
  float minLat = 41.87, maxLat = 46.95;
  float minLon = -83.051, maxLon = -70.928;
  
  //feeding into the stretmap
  streetMap = new TileMap(minLat, maxLat, minLon, maxLon, 7, 7, 9);

  // center offsets at start
  float startLon = (minLon + maxLon) / 2;
  float startLat = (minLat + maxLat) / 2;
  float centerTileX = longToXTile(startLon, streetMap.currentZoom);
  float centerTileY = latToYTile(startLat, streetMap.currentZoom);
  xOffSet = width/2 - centerTileX * tileSize;
  yOffSet = height/2 - centerTileY * tileSize ;
  
  loadCity();
  loadAttractions();
}

void draw() {
  background(0);
  
  pushMatrix();
  translate(width/2, height/2);  // ← FIX: Scale around center
  scale(displayScale);
  translate(-width/2, -height/2);
  
  // Update tiles
  if (simulateMap) {
     streetMap.update(xOffSet, yOffSet);
     streetMap.drawTiles();
  }
  
  // Draw road INSIDE the scaled section
  if (drawRoad && roadPoints != null) {  // ← FIX: Check for null
    drawRoad(roadPoints);
  }
  
  popMatrix();  // ← Scaling ends here
  

  for (attractions a : attractionList) {
    a.checkInRange();
    a.update();

    if (a.inRange) {
      a.checkCategory();
      a.showOnMap();
    }
  }
  
  // Calendar code (not scaled)
  if (showCalendar){
    image(calendarImg, 150, 300);
    for (int i = 0; i < events.size(); i++){
      events.get(i).drawEvent();
    }
  }
  
  // Center marker (not scaled)
  fill(255, 0, 0);
  circle(width/2, height/2, 5);
  
   // ADD THIS at the very end, AFTER popMatrix():
  float mouseTileX = (mouseX - xOffSet) / tileSize;
  float mouseTileY = (mouseY - yOffSet) / tileSize;
  fill(0,0,0); // Yellow text
  textSize(16);
  text("Tile under cursor: " + nf(mouseTileX, 1, 2) + ", " + nf(mouseTileY, 1, 2), 10, height - 20);
  
}
