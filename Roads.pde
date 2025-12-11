class Location{
 String name;
 float lat, lon, x, y, targetX, targetY;
 
 Location(String n, float lat, float lon){
   this.name = n;
   this.lat = lat;
   this.lon = lon;
   updateTargets();
   this.x = targetX;
   this.y = targetY;
 }
 
 Location(float lat, float lon) { 
   this.lat = lat;
   this.lon = lon;
   updateTargets();
   this.x = targetX;
   this.y = targetY;
 }
 
 void updateTargets() {
   targetX = latLonToScreenX(lon, streetMap.currentZoom) - 128;
   targetY = latLontoScreenY(lat, streetMap.currentZoom) - 128;
 }
 
 void update() {
   updateTargets();
   x += (targetX - x) * 0.3;
   y += (targetY - y) * 0.3;
 }
}

float roadAnimProgress = 0;
boolean roadAnimating = false;

ArrayList<Location> retrievePoints(ArrayList<Location> stops) {
   ArrayList<Location> roadPoint = new ArrayList<Location>();
   String coordsRequested = "";
   
   for (int i = 0; i < stops.size(); i++) {
     Location c = stops.get(i);
     coordsRequested += c.lon + "," + c.lat;
     if (i < stops.size()-1) coordsRequested += ";";
   }
   
   String url = String.format("http://router.project-osrm.org/route/v1/driving/%s?overview=full&geometries=geojson", coordsRequested);
   
   try {
     JSONObject routeData = loadJSONObject(url);
     if (routeData != null && routeData.getString("code").equals("Ok")) {
       JSONObject routeObj = routeData.getJSONArray("routes").getJSONObject(0);
       routeDistance = routeObj.getFloat("distance");
       routeDuration = routeObj.getFloat("duration");
       
       JSONArray coords = routeObj.getJSONObject("geometry").getJSONArray("coordinates");
       println("Fetching " + coords.size() + " road points");
       
       for (int i = 0; i < coords.size(); i++) { 
         JSONArray pt = coords.getJSONArray(i);
         roadPoint.add(new Location(pt.getFloat(1), pt.getFloat(0)));
       }
       
       roadAnimProgress = 0;
       roadAnimating = true;
     }
     return roadPoint;
   } catch (Exception e) {
     println("OSRM error: " + e.getMessage());
     return null;
   }
}

void drawRoad(ArrayList<Location> places) {
  if (places == null || places.isEmpty()) return;
  
  if (roadAnimating) {
    roadAnimProgress = min(roadAnimProgress + 0.02, 1.0);
    if (roadAnimProgress >= 1.0) roadAnimating = false;
  }
  
  int numPoints = constrain((int)(places.size() * roadAnimProgress), 2, places.size());
  
  stroke(50, 150, 255, 200);
  strokeWeight(4 / displayScale);
  noFill();
  
  beginShape();
  for (int i = 0; i < numPoints; i++) {
    places.get(i).update();
    vertex(places.get(i).x, places.get(i).y);
  }
  endShape();
}
