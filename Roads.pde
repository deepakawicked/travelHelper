

void retrievePoints(ArrayList<PVector> stops) {
   String coordsRequested = "";
   
   for (int i = 0; i < stops.size(); i++) {
     PVector c = stops.get(i);
     coordsRequested += c.x + "," + c.y;
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
       
       for (int i = 0; i < coords.size(); i++) {
         JSONArray point = coords.getJSONArray(i);
         float lon = point.getFloat(0); // first element is the longtitude 
         float lat = point.getFloat(1); //second element is latitude 
       }
     } 
 
   }
   
   catch (Exception e) {
     println("Unable to Load RouteData from ORSM" + e.getMessage());
   
   
   }
   
}
