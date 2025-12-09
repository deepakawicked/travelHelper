void loadCity(){
  String[] cityLines = loadStrings("city.txt");
  
  for(int i = 0; i<cityLines.length;i++){
    String currLine = cityLines[i];
    String[] parts = currLine.split("\\s+");
    
    String cityName = parts[0];
    //String cityPos = parts[1];
    String[] coordStrings = parts[parts.length - 1].split(",");

    float lat = float(coordStrings[0].trim());
    float lon = float(coordStrings[1].trim());

    //PVector position = new PVector(lat, lon);
    
    city c = new city(cityName, lat, lon);
    c.checkPicked();
    c.update();
    if(c.getPicked == true){
      c.showOnMap();
    }
  }
}


void loadAttractions() { 
  String[] lines = loadStrings("attractions.txt"); 
  for (int i = 0; i < lines.length; i++) { 
    String curr = lines[i].trim(); 
    String[] parts = curr.split("\\s+"); 
    String name = parts[0]; 
    float rating = float(parts[1]); 
    String category = parts[2]; 
    String pos = parts[3]; 
    String[] coord = pos.split(","); 
    float lat = float(coord[0].trim()); 
    float lon = float(coord[1].trim()); 
    //PVector position = new PVector(lat, lon); 
    attractions a = new attractions(name, rating, lat, lon, category); 
    a.checkInRange(); 
    a.update();
   if (a.inRange == true){ 
      a.checkCategory();
      a.showOnMap(); 
    }
  }
}



class location{
 String name;
 float lat, lon;
 float x, y;
 
 location(String n, float lat, float lon){
   this.name = n;
   this.lat = lat;
   this.lon = lon;
 }
 
 void update() { //scale with offset 
   this.x = latLonToScreenX(this.lon, streetMap.currentZoom);
   this.y = latLongtoScreenY(this.lat, streetMap.currentZoom);
 }
 
 
}

float startingLong, startingLat, endingLong, endingLat;
String startingCity;
String endingCity;

class city extends location {
  boolean getPicked = false;
  
  city(String n, float lat, float lon){
   super(n,lat, lon); 
  }
  
  void checkPicked(){
    if (this.name.equals(startingCity)){
      this.getPicked = true;
      startingLong = this.lon;
      startingLat = this.lat;
    }
    else if (this.name.equals(endingCity)){
      this.getPicked = true;
      endingLat = this.lat;
      endingLong = this.lon;
    }
  }
  
  void showOnMap(){
    cityMarker = loadImage("cityMarker.png");
    image(cityMarker, this.x, this.y, 30,30);
    text(this.name, this.x+20, this.y);
  }
  
//  void showCity(){
//   text(this.name, this.position.x, this.position.y); 
//  }
}


class attractions extends location{
  float rating;
  String category;
  boolean inRange, food, touristHotspot, nature, museum;
  
  attractions(String n, float r, float lat, float lon, String c){
   super(n,lat, lon);
   this.rating = r;
   this.category = c;
   this.inRange = false;
  }
  
  void checkInRange(){
    if(startingLong - 1 < this.lon && this.lon < endingLong + 1 ||endingLong - 1 < this.lon && this.lon < startingLong + 1){
      if(startingLat - 1 < this.lat && this.lat < endingLat + 1 || endingLat - 1 < this.lat && this.lat < startingLat){
       this.inRange = true; 
      }
    }
  }
  
  void checkCategory(){
    if(this.category == "food"){
      this.food = true;
    }else if(this.category == "touristHotspot"){
     this.touristHotspot = true; 
    }else if(this.category == "nature"){
     this.nature = true;
    }else{
     this.museum = true; 
    }
  }
  
  void showOnMap(){
    attractionMarker = loadImage("attractionMarker.png");
    image(attractionMarker, this.x, this.y, 30,30);
    text(this.name, this.x+20, this.y);
  }
  
//  void showAttractions(){
//   text(this.name + this.rating, this.position.x, this.position.y); 
//  }
  
}
