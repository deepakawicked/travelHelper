import g4p_controls.*;

TileMap streetMap;

//simulate the map, used for debugging and turning off the map if needed 
boolean simulateMap = true;
String apiKey = ""; // MapTiler API key, not included in push

//dragging and map movement 
float xOffSet, yOffSet;
float dragStartX, dragStartY;
boolean dragging;

// scrolling and zoom size 
float displayScale = 1.0;
float zoomStep = 0.1;
float tileSize = 256; //tile set to the default amount 
 


//Calendar variables
ArrayList <Event> events = new ArrayList <Event>();
boolean showCalendar;
PImage calendarImg, logo, bg, cityMarker, attractionMarker;
PFont font; 


//routeDistance and information 
float routeDistance;  
float routeDuration; 
City startCity, endCity;
Boolean drawRoad = false;
ArrayList<Location> roadPoints;
int numPoints;
//road animaton
float roadAnimProgress = 0; 
boolean roadAnimating = false;

ArrayList<attractions> viable = new ArrayList <attractions>();
boolean showInfo = false;

void setup() {
  frameRate(30); //cap the frameRate to help lower end PCS.
  createGUI();
  
  eventswin.setVisible(false);
  
  
  size(800, 800);
  font = createFont("Times New Roman", 15);
  textFont(font);
  
  //calendar image
  imageMode(CENTER);
  calendarImg = loadImage("calendar.png");
  calendarImg.resize(250,0);
 
 //load the logo and background image 
  logo = loadImage("journeylog.png");
  bg = loadImage("background.png");
  
  
  // bounding box for Ontario and Quebec, extended out a bit to help with the background naf loops 
  float minLat = 41.0, maxLat = 47.5;
  float minLon = -84.0, maxLon = -70.0;
  
  //create the new StreetMap object (tileMap class), while will mange the files 
  streetMap = new TileMap(minLat, maxLat, minLon, maxLon, 7, 7, 9);

  // start at the center of the scren
  float startLon = (minLon + maxLon) / 2;
  float startLat = (minLat + maxLat) / 2;
  
  
  //convert to world coodernates 
  float centerTileX = longToXTile(startLon, streetMap.currentZoom); 
  float centerTileY = latToYTile(startLat, streetMap.currentZoom);
  
  
  //set the offset into the wolrd screen
  xOffSet = width/2 - centerTileX * tileSize;
  yOffSet = height/2 - centerTileY * tileSize ;
  
  //load city and document from the text files 
  loadCity();
  loadAttractions();
}

void draw() {
  background(205, 231, 197); //green backgrounds to match the map (helps with blending and easing transitions)
  
  pushMatrix(); //push the transformation of the map, the street, marker (attractions) onto a seperate tile system
  
  //scale to the center of the screen only 
  translate(width/2, height/2);  
  scale(displayScale);
  translate(-width/2, -height/2); //restore to the previous measurement 
  
  
  if (simulateMap) {
     streetMap.update(xOffSet, yOffSet); //add the offset from mousedrag to the current tiles 
     streetMap.drawTiles(); //draw all visible tiles 
  }
  
  if (drawRoad && roadPoints != null) {  //draw road if requested from the GUI (OSRM Data must be first fetched)
    drawRoad(roadPoints);
  }
  
  //check all attractions 
  for (attractions a : attractionList) {
    a.checkInRange(); //check if their in range of the map (current world view fro the applicaiton)
    a.update(); //update positions based on the tile offset (built off the Locattion class
    
    
    //filter attractions 
    if (a.inRange) { //if in the map views 
      if (a.category.equals(category.getSelectedText())){ //matchs the selected one 
        if (a.rating >= stars.getValueI()){   //meets minimum require (from the slider)    
        
          if (a.category.equals("Food")){ //checks the food catagory
            if(a.budget == budget.getValueI()){
              
              //if no visible, add to the visible list 
              if (viable.contains(a) == false) viable.add(a);
              a.showOnMap(); //display on map 
            }
            else if (viable.contains(a)) viable.remove(a);
          }
          else{
            a.showOnMap(); //display non-food attracitons 
            if (viable.contains(a) == false) viable.add(a);
          }
        }
        else if (viable.contains(a)) viable.remove(a);
      }
      else if (viable.contains(a)) viable.remove(a);
    }
    else if (viable.contains(a)) viable.remove(a);
  }
  
  popMatrix(); //restore to another matrix stack, which is not affected by mouse drag and zoomng 
  

  if (showCalendar){ //popping the matrix allows the calender to stay flush on screen the whole time 
    image(calendarImg, 150, 300);
    for (int i = 0; i < events.size(); i++){
      events.get(i).drawEvent();
    }
  }
  
  
  //display info BOXES 
  if (showInfo && roadPoints != null){ //  if the user wants to see the route info 
    int mid = numPoints/2; // pick a middle pint to display info 
    fill(255);
    rect(roadPoints.get(mid).x, roadPoints.get(mid).y + 10, 120, 60); //draw background box 
    fill(0);
    int hours = int(((routeDuration - (routeDuration % 3600))/3600)); //calculate hours 
    int mins = round((routeDuration % 3600)/60); //calculate minutes 
    textSize(16);
    text(hours + " hr " + mins + " min", roadPoints.get(mid).x+10, roadPoints.get(mid).y + 30); //format the text 
    
    int distance = round(routeDistance/1000); //convert meters to kim
    text(distance + " km", roadPoints.get(mid).x+10, roadPoints.get(mid).y + 60); //display distance 
  }
  if (selected != null && showCalendar == false){ //display selected attraction/event info
    textAlign(LEFT);
    fill(255);
    rect(selected.x, selected.y, 150, 80); //background box 
    fill(255,230,230);
    rect(selected.x+60, selected.y + 45, 80, 30);
    fill(0);
    textSize(14);
    text(selected.name, selected.x + 10, selected.y + 15); //name
    text(selected.category, selected.x + 10, selected.y + 32); //catagory 
    text(int(selected.rating) + "/10", selected.x + 10, selected.y + 49); //rating 
    textSize(14);
    textAlign(CENTER);
    text("Create Event", selected.x + 100, selected.y + 65); //button text 
    textAlign(LEFT);
  }
 
  
}
