ArrayList<city> cities = new ArrayList<city>();
ArrayList<attractions> attractionList = new ArrayList<attractions>();


void loadCity() {
  String[] citynames = loadStrings("city name.txt");
  String[] citypos = loadStrings("city position.txt");

  for (int i = 0; i < citypos.length; i++) {

    String cityName = citynames[i];
    String coordStrings = citypos[i];
    String[] cityLonLat = coordStrings.split(", ");
    float lat = float(cityLonLat[0]);
    float lon = float(cityLonLat[1]);

    city c = new city(cityName, lat, lon);
    cities.add(c);
    //c.checkPicked();
    //c.update();
    //if (c.getPicked == true) {
    //  c.showOnMap();
    //}
  }
}

void loadAttractions() {
  String[] lines = loadStrings("attractions.txt");
  String[] attractionName = loadStrings("attraction name.txt");
  String[] attractionRating = loadStrings("attraction rating.txt");
  String[] attractionCategory = loadStrings("attraction category.txt");
  String[] attractionPosition = loadStrings("attraction position.txt");

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

class city extends Location {
  boolean getPicked = false;

  city(String n, float lat, float lon) {
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
