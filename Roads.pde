
//represents a geographic location, or "point" on the map. using for attractions, Cities, and road points 
class Location{
 String name;
 float lat, lon, x, y, targetX, targetY;
 
 //constructor with names (for cities and attractions)
 Location(String n, float lat, float lon){
   this.name = n;
   this.lat = lat;
   this.lon = lon;
   updateTargets();
   this.x = targetX;
   this.y = targetY;
 }
 
 //contructors without a name (used for attractions)
 Location(float lat, float lon) { 
   this.lat = lat;
   this.lon = lon;
   updateTargets();
   this.x = targetX;
   this.y = targetY;
 }
 
 //update target screen positon with map zoom and offset (using the offset function found in the helper functions)
 void updateTargets() {
   targetX = latLonToScreenX(lon, streetMap.currentZoom) - 128; //offset given to line roads with map
   targetY = latLontoScreenY(lat, streetMap.currentZoom) - 128;
 }
 
 //smoothly move current postion toward target positon 
 void update() {
   updateTargets(); //recaculate target in case of map movement (user drag and input)
   x += (targetX - x) * 0.3; //smoothhly interpolate for animation 
   y += (targetY - y) * 0.3; //higher zoom factor to prevent the "jumping" of points 
 }
}


//Fetch local poitns from ORSM API between a set of stops 
ArrayList<Location> retrievePoints(ArrayList<Location> stops) { //the stopos can be cities, attractions, or location road point due to the inheritance 
   ArrayList<Location> roadPoint = new ArrayList<Location>();
   String coordsRequested = "";
   
   //Build semi-colon-seperated lon, lat, string for ORSM API
   for (int i = 0; i < stops.size(); i++) {
     Location c = stops.get(i);
     coordsRequested += c.lon + "," + c.lat;
     if (i < stops.size()-1) coordsRequested += ";";
   }
   
   //create the URL link with the coodernates 
   String url = String.format("http://router.project-osrm.org/route/v1/driving/%s?overview=full&geometries=geojson", coordsRequested);
   
   try { //prevent any errors if the API returns bad or sow 
      
      //only proceed if the API (Json file) returns "ok"
     JSONObject routeData = loadJSONObject(url);
     if (routeData != null && routeData.getString("code").equals("Ok")) { //the key, allowing acces to the data 
       JSONObject routeObj = routeData.getJSONArray("routes").getJSONObject(0); //naviagate to the route data set 
       routeDistance = routeObj.getFloat("distance"); //total route distance 
       routeDuration = routeObj.getFloat("duration"); //estimated duration in seconds 
       
       JSONArray coords = routeObj.getJSONObject("geometry").getJSONArray("coordinates"); //navigate to the road points 
       
      
      //
       for (int i = 0; i < coords.size(); i++) { 
         JSONArray pt = coords.getJSONArray(i); //create an object to get the poitn
         roadPoint.add(new Location(pt.getFloat(1), pt.getFloat(0))); //asign in the roadPoint class 
       }
       
       roadAnimProgress = 0; //Reset animation progress
       roadAnimating = true; //start road drawing animation
     }
     return roadPoint;
   } catch (Exception e) {
     println("OSRM error: " + e.getMessage()); //Record the erorr to the user in the console 
     return null; //break out 
   }
}

//draw a smooth road animation connect a list of locations 
void drawRoad(ArrayList<Location> places) {
  if (places == null || places.isEmpty()) return; //nothing to draw
  
  //update animation progress smothly (smoothly draw road over time)
  if (roadAnimating) {
    roadAnimProgress = min(roadAnimProgress + 0.02, 1.0);
    if (roadAnimProgress >= 1.0) roadAnimating = false;
  }
  
  //determine the points of the road based on animation progress 
  int totalPoints = places.size();
  int pointsToDraw = (int)(totalPoints * roadAnimProgress);

  // Ensure at least 2 points and no more than total points
  if (pointsToDraw < 2) pointsToDraw = 2;
  if (pointsToDraw > totalPoints) pointsToDraw = totalPoints;
  numPoints = pointsToDraw;

  
  stroke(50, 150, 255, 200); //Road color
  strokeWeight(4 / displayScale); //scale stroke (size) with zoom, to prevent it eclipsing detail
  noFill();
  
  //draw the road as a connected lne 
  beginShape();
  for (int i = 0; i < numPoints; i++) {
    places.get(i).update(); //smoothly move points 
    vertex(places.get(i).x, places.get(i).y);
  }
  endShape(); //end shape 
}
