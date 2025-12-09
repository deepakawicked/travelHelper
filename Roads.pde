

class Location{
 String name;
 float lat, lon;
 float x, y;
 
 Location(String n, float lat, float lon){
   this.name = n;
   this.lat = lat;
   this.lon = lon;
   
   
 }
 
 Location(float lat, float lon) { //other constructor for points 
   this.lat = lat;
   this.lon = lon;
    
   
 }
 
 void update() { //scale with offset 
   this.x = latLonToScreenX(this.lon, streetMap.currentZoom) - 128;
   this.y = latLontoScreenY(this.lat, streetMap.currentZoom)-128;
 }
 

 
 
}


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
     
     if (routeData!= null && routeData.getString("code").equals("Ok")) {
       JSONObject routeObj = routeData.getJSONArray("routes").getJSONObject(0);
       
       routeDistance = routeObj.getFloat("distance"); //get the distance of the fastest path
       routeDuration = routeObj.getFloat("duration"); //get the duration of the fastest path
       
       JSONArray coords = routeObj.getJSONObject("geometry").getJSONArray("coordinates"); //navigate to the coodernates
       println("Fetching points..." + coords.size() + " found!");
       for (int i = 0; i < coords.size(); i++) { 
         JSONArray pointData = coords.getJSONArray(i);
         float lon = pointData.getFloat(0); // first element is the longtitude 
         float lat = pointData.getFloat(1); //second element is latitude 
         Location point = new Location(lat, lon);
         roadPoint.add(point);
         
         
       }
     } 
     
    
     return roadPoint;
 
   }
   
   catch (Exception e) {
     println("Unable to Load RouteData from ORSM" + e.getMessage());
     return null;
   
   }
   
}

void drawRoad(ArrayList<Location> places) {
  stroke(255, 0, 0);  // Red so you can see it
  strokeWeight(4 / displayScale);  // ← FIX: Account for scale
  noFill();
  
  beginShape();  // ← Better way to draw continuous line
  for (Location loc : places) {
    loc.update();
    vertex(loc.x, loc.y);
  }
  endShape();
  
println("Current map zoom: " + streetMap.currentZoom);
println("Tile at Toronto should be: " + longToXTile(-79.3832, streetMap.currentZoom) + ", " + latToYTile(43.6532, streetMap.currentZoom));
  
}
