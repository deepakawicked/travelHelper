////<<<<<<< Updated upstream
////class attractions extends location{
////  float rating;
////  String category;
  
////  attractions(String a, float r, PVector p, String c){
////   super(a,p);
////   this.rating = r;
////   this.category = c;
////  }
////}
////=======

//void loadCity(){
//  String[] cityLines = loadStrings("city.txt");
  
//  for(int i = 0; i<cityLines.length;i++){
//    String currLine = cityLines[i];
//    String[] parts = currLine.split("\\s+");
    
//    String cityName = parts[0];
//    String cityPos = parts[1];
//    String[] coordStrings = cityPos.split(",");

//    float lat = float(coordStrings[0].trim());
//    float lon = float(coordStrings[1].trim());

//    PVector position = new PVector(lat, lon);
//  }
//}

//void loadAttractions() {
//  String[] lines = loadStrings("attractions.txt");

//  for (int i = 0; i < lines.length; i++) {
//    String curr = lines[i].trim();

//    String[] parts = curr.split("\\s+");

//    String name = parts[0];
//    float rating = float(parts[1]);
//    String category = parts[2];
//    String pos = parts[3];

//    String[] coord = pos.split(",");
//    float lat = float(coord[0].trim());
//    float lon = float(coord[1].trim());

//    PVector position = new PVector(lat, lon);
//  }
//}




//class location{
// String name;
// PVector position;
 
// location(String n, PVector p){
//   this.name = n;
//   this.position.x = (p.y + 83.5)*57;
//   this.position.y = (-1*p.x + 48.5)*110;
// }
 
//}




//class attractions extends location{
//  float rating;
//  String category;
//  boolean inRange, food, touristHotspot, nature, museum;
//  PVector startingPosition;
//  PVector endingPosition;
  
//  attractions(String n, float r, PVector p, String c){
//   super(n,p);
//   this.rating = r;
//   this.category = c;
//   this.inRange = false;
//  }
  
//  void checkInRange(){
//    if (startingPosition.x - 50 < this.position.x && this.position.x < endingPosition.x + 50 && startingPosition.y - 50 < this.position.y && this.position.y < endingPosition.y + 50 ||
//    endingPosition.x - 50 < this.position.x && this.position.x < startingPosition.x + 50 && endingPosition.y - 50 < this.position.y && this.position.y < startingPosition.y + 50){
//      this.inRange = true;
//    }
//  }
  
//  void checkCategory(){
//    if(this.category == "food"){
//      this.food = true;
//    }else if(this.category == "touristHotspot"){
//     this.touristHotspot = true; 
//    }else if(this.category == "nature"){
//     this.nature = true;
//    }else{
//     this.museum = true; 
//    }
//  }
  
//  void showAttractions(){
//   text(this.name + this.rating, this.position.x, this.position.y); 
//  }
  
//}
////>>>>>>> Stashed changes



//class city extends location {
  
//  city(String n, PVector p){
//   super(n,p); 
//  }
  
//  void checkPicked(){
//    if (this.name == startCity){
//    startingPosition = this.position;
//    }
//    else if (this.name == endCity){
//     endingPosition = this.position;
//    }
//  }
  
//  void showCity(){
//   text(this.name, this.position.x, this.position.y); 
//  }
//}
