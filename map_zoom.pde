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

ArrayList<attractions> viable = new ArrayList <attractions>();
boolean showInfo = false;

void setup() {
  frameRate(30);
  createGUI();
  eventswin.setVisible(false);
  size(800, 800);
  font = createFont("Times New Roman", 15);
  textFont(font);
  
  //calendar image
  imageMode(CENTER);
  calendarImg = loadImage("calendar.png");
  calendarImg.resize(250,0);
 
  logo = loadImage("journeylog.png");
  bg = loadImage("background.png");
  
  
  // Example bounding box for Ontario + Quebec
  float minLat = 41.0, maxLat = 47.5;
  float minLon = -84.0, maxLon = -70.0;
  
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
  background(205, 231, 197);
  
  pushMatrix();
  translate(width/2, height/2);  // ← FIX: Scale around center
  scale(displayScale);
  translate(-width/2, -height/2);
  
  
  if (simulateMap) {
     streetMap.update(xOffSet, yOffSet);
     streetMap.drawTiles();
  }
  
  if (drawRoad && roadPoints != null) {  // ← FIX: Check for null
    drawRoad(roadPoints);
  }
  
  for (attractions a : attractionList) {
    a.checkInRange();
    a.update();

    if (a.inRange) {
      if (a.category.equals(category.getSelectedText())){
        if (a.rating >= stars.getValueI()){          
          if (a.category.equals("Food")){
            if(a.budget == budget.getValueI()){
              
              if (viable.contains(a) == false) viable.add(a);
              a.showOnMap();
            }
            else if (viable.contains(a)) viable.remove(a);
          }
          else{
            a.showOnMap();
            if (viable.contains(a) == false) viable.add(a);
          }
        }
        else if (viable.contains(a)) viable.remove(a);
      }
      else if (viable.contains(a)) viable.remove(a);
    }
    else if (viable.contains(a)) viable.remove(a);
  }
  
  popMatrix();  
  

  if (showCalendar){
    image(calendarImg, 150, 300);
    for (int i = 0; i < events.size(); i++){
      events.get(i).drawEvent();
    }
  }
  
  if (showInfo && roadPoints != null){
    int mid = numPoints/2;
    fill(255);
    rect(roadPoints.get(mid).x, roadPoints.get(mid).y + 10, 120, 60);
    fill(0);
    int hours = int(((routeDuration - (routeDuration % 3600))/3600));
    int mins = round((routeDuration % 3600)/60);
    textSize(16);
    text(hours + " hr " + mins + " min", roadPoints.get(mid).x+10, roadPoints.get(mid).y + 30);
    
    int distance = round(routeDistance/1000);
    text(distance + " km", roadPoints.get(mid).x+10, roadPoints.get(mid).y + 60);
  }
  if (selected != null && showCalendar == false){
    textAlign(LEFT);
    fill(255);
    rect(selected.x, selected.y, 150, 80);
    fill(255,230,230);
    rect(selected.x+60, selected.y + 45, 80, 30);
    fill(0);
    textSize(14);
    text(selected.name, selected.x + 10, selected.y + 15);
    text(selected.category, selected.x + 10, selected.y + 32);
    text(int(selected.rating) + "/10", selected.x + 10, selected.y + 49);
    textSize(14);
    textAlign(CENTER);
    text("Create Event", selected.x + 100, selected.y + 65);
    textAlign(LEFT);
  }
  
  float mouseTileX = (mouseX - xOffSet) / tileSize;
  float mouseTileY = (mouseY - yOffSet) / tileSize;
  fill(0,0,0); // Yellow text
  textSize(16);
  text("Tile under cursor: " + nf(mouseTileX, 1, 2) + ", " + nf(mouseTileY, 1, 2), 10, height - 20);
  
}
