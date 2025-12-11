ArrayList<attractions> attractionList = new ArrayList<attractions>();
ArrayList<City> cityList = new ArrayList<City>();

void loadCity() { //loads the cities and stores data 
  String[] cityData  = loadStrings("city.txt");
  
  for(int i = 0; i < cityData.length; i++) {
     String currentString = cityData[i];
     String[] listData = split(currentString, ",");
     String cityName = listData[0].trim();
     float cityLat = float(listData[1].trim());
     float cityLong = float(listData[2].trim());
     
     
     City newCity = new City(cityName, cityLat, cityLong);
     cityList.add(newCity);
     
  }

}

void loadAttractions() {
  String[] lines = loadStrings("attraction/attractions.txt");
  String[] attractionName = loadStrings("attraction/attraction name.txt");
  String[] attractionRating = loadStrings("attraction/attraction rating.txt");
  String[] attractionCategory = loadStrings("attraction/attraction category.txt");
  String[] attractionBudget = loadStrings("attraction/attraction price.txt");
  String[] attractionPosition = loadStrings("attraction/attraction position.txt");

  for (int i = 0; i < lines.length; i++) {

    String name = attractionName[i];
    float rating = float(attractionRating[i]);
    String category = attractionCategory[i];
    String budgetText = attractionBudget[i]; 
    String pos = attractionPosition[i];

    String[] coord = pos.split(", ");
    
    float lat = float(coord[0]);
    float lon = float(coord[1]);
    
    int budget = 0;
    if (budgetText.equals("$")) budget = 1;
    else if (budgetText.equals("$$")) budget = 2;
    else budget = 3;
    
    attractions a = new attractions(name, rating, lat, lon, category, budget);

    attractionList.add(a);    a.checkInRange();
    a.update();

  }
}


float startingLong, startingLat, endingLong, endingLat;
String startingCity;
String endingCity;

class City extends Location {
  boolean getPicked = false;

  City(String n, float lat, float lon) {
    super(n, lat, lon);
  }

  void checkPicked() {
    if (this.name.equals(startingCity)) {
      this.getPicked = true;
      startingLong = this.lon;
      startingLat = this.lat;
    } else if (this.name.equals(endingCity)) {
      this.getPicked = true;
      endingLat = this.lat;
      endingLong = this.lon;
    }
  }

  void showOnMap() {
    println("hello");
    cityMarker = loadImage("cityMarker.png");
    image(cityMarker, this.x, this.y, 30, 30);
    textFont(font);
    textAlign(CENTER);
    fill(255);
    text(this.name, this.x+20, this.y);
  }
}


class attractions extends Location {
  int budget;
  float rating;
  String category;
  boolean inRange, food, touristHotspot, nature, museum;

  attractions(String n, float r, float lat, float lon, String c, int b) {
    super(n, lat, lon);
    this.rating = r;
    this.category = c;
    this.budget = b;
    this.inRange = false;
  }

  void checkInRange() {
    //if (startingLong - 1 < this.lon && this.lon < endingLong + 1 ||endingLong - 1 < this.lon && this.lon < startingLong + 1) {
    //  if (startingLat - 1 < this.lat && this.lat < endingLat + 1 || endingLat - 1 < this.lat && this.lat < startingLat) {
    //    this.inRange = true;
    //  }
    //}
    this.inRange = true;
  }



   void showOnMap() {
    attractionMarker = loadImage("attractionMarker.png");
    image(attractionMarker, this.x, this.y, 30/displayScale, 30/displayScale);
    textSize(10/displayScale);
    text(this.name, this.x+20/displayScale, this.y);
  }
  
}
