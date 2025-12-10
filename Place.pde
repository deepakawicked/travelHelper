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
  String[] attractionPosition = loadStrings("attraction/attraction position.txt");

  for (int i = 0; i < lines.length; i++) {

    String name = attractionName[i];
    float rating = float(attractionRating[i]);
    String category = attractionCategory[i];
    String pos = attractionPosition[i];

    String[] coord = pos.split(", ");

    float lat = float(coord[0]);
    float lon = float(coord[1]);

    attractions a = new attractions(name, rating, lat, lon, category);

    attractionList.add(a);    a.checkInRange();
    a.update();

    if (a.inRange == true) {
      a.checkCategory();
      a.showOnMap();
    }
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
    cityMarker = loadImage("cityMarker.png");
    image(cityMarker, this.x, this.y, 30, 30);
    text(this.name, this.x+20, this.y);
  }
}


class attractions extends Location {
  float rating;
  String category;
  boolean inRange, food, touristHotspot, nature, museum;

  attractions(String n, float r, float lat, float lon, String c) {
    super(n, lat, lon);
    this.rating = r;
    this.category = c;
    this.inRange = false;
  }

  void checkInRange() {
    if (startingLong - 1 < this.lon && this.lon < endingLong + 1 ||endingLong - 1 < this.lon && this.lon < startingLong + 1) {
      if (startingLat - 1 < this.lat && this.lat < endingLat + 1 || endingLat - 1 < this.lat && this.lat < startingLat) {
        this.inRange = true;
      }
    }
  }

  void checkCategory() {
    if (this.category == "food") {
      this.food = true;
    } else if (this.category == "touristHotspot") {
      this.touristHotspot = true;
    } else if (this.category == "nature") {
      this.nature = true;
    } else {
      this.museum = true;
    }
  }

  void showOnMap() {
    attractionMarker = loadImage("attractionMarker.png");
    image(attractionMarker, this.x, this.y, 30, 30);
    text(this.name, this.x+20, this.y);
  }
  
}
