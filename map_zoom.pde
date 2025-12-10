import g4p_controls.*;

TileMap streetMap;

// Simulation and API
boolean simulateMap = true;
String apiKey = "8N3PDuIB3twtbBgKkj4B"; // MapTiler API key

// Dragging
float xOffSet, yOffSet;
float dragStartX, dragStartY;
boolean dragging;

// Zoom
float displayScale = 1.0;
float zoomStep = 0.1;
float tileSize = 256;

// Calendar variables (untouched)
ArrayList<Event> events = new ArrayList<Event>();
boolean showCalendar;
PImage calendarImg, logo, bg, cityMarker, attractionMarker;
PFont font;
float routeDistance, routeDuration;
String startPlace, endPlace;
boolean drawRoad = false;
ArrayList<Location> roadPoints;

void setup() {
  createGUI();
  size(800, 800);
  font = createFont("Times New Roman", 15);

  // Calendar image
  imageMode(CENTER);
  calendarImg = loadImage("calendar.png");
  calendarImg.resize(250, 0);

  logo = loadImage("journeylog.png");
  bg = loadImage("background.png");

  // Bounding box for Ontario + Quebec
  float minLat = 41.87, maxLat = 46.95;
  float minLon = -83.051, maxLon = -70.928;

  // Initialize TileMap
  streetMap = new TileMap(minLat, maxLat, minLon, maxLon, 7, 7, 9);

  // Center the map
  float startLon = (minLon + maxLon) / 2;
  float startLat = (minLat + maxLat) / 2;
  xOffSet = width/2 - longToXTile(startLon, streetMap.currentZoom) * tileSize;
  yOffSet = height/2 - latToYTile(startLat, streetMap.currentZoom) * tileSize;
}

void draw() {
  background(0);

  pushMatrix();

  // Apply scaling based on displayScale
  translate(mouseX , mouseY);
  scale(displayScale);
  translate(-mouseX , -mouseY);

  // Draw tiles normally using offsets
  if (simulateMap) {
    streetMap.update(xOffSet, yOffSet);
    streetMap.drawTiles();
  }

  // Draw road if any
  if (drawRoad && roadPoints != null) {
    drawRoad(roadPoints);
  }

  popMatrix();


  if (showCalendar){
    image(calendarImg, 150, 300);
    for (int i = 0; i < events.size(); i++){
      events.get(i).drawEvent();
    }
  }

  // Mouse tile under cursor
  float mouseTileX = (mouseX - xOffSet) / tileSize;
  float mouseTileY = (mouseY - yOffSet) / tileSize;
  fill(0, 0, 0);
  textSize(16);
  text("Tile under cursor: " + nf(mouseTileX, 1, 2) + ", " + nf(mouseTileY, 1, 2), 10, height - 20);
}
