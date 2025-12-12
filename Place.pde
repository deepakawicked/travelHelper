// ---- Load Cities and Attractions Data ----
ArrayList<attractions> attractionList = new ArrayList<attractions>();
ArrayList<City> cityList = new ArrayList<City>();
//making two array list to store cities and attractions

void loadCity() {
//load the cities and store the data 

  String[] cityData  = loadStrings("city.txt");
  
  for(int i = 0; i < cityData.length; i++) {
     String currentString = cityData[i];
     String[] listData = split(currentString, ",");
     String cityName = listData[0].trim();
     float cityLat = float(listData[1].trim());
     float cityLong = float(listData[2].trim());
     //load the city data
     
     
     City newCity = new City(cityName, cityLat, cityLong);
     cityList.add(newCity);
     //store the data that we just loaded in   
  }
}

void loadAttractions() {
  //load the attractions and store the data (files are split due to an ememwnce amount of data)
  String[] attractionName = loadStrings("attraction/attraction name.txt");
  String[] attractionRating = loadStrings("attraction/attraction rating.txt");
  String[] attractionCategory = loadStrings("attraction/attraction category.txt");
  String[] attractionBudget = loadStrings("attraction/attraction price.txt");
  String[] attractionPosition = loadStrings("attraction/attraction position.txt");

  for (int i = 0; i < attractionName.length; i++) {
    
    //set a fild per each file 
    String name = attractionName[i];
    float rating = float(attractionRating[i]);
    String category = attractionCategory[i];
    String budgetText = attractionBudget[i]; 
    String pos = attractionPosition[i];

    String[] coord = pos.split(", ");
    
    float lat = float(coord[0]);
    float lon = float(coord[1]);
    //load the attractions data
    
    int budget = 0;
    if (budgetText.equals("$")) budget = 1;
    else if (budgetText.equals("$$")) budget = 2;
    else budget = 3;
    //load the budget
    
    attractions a = new attractions(name, rating, lat, lon, category, budget);
    attractionList.add(a);    
    a.checkInRange();
    a.update();
    //store the attractions data into the arraylist

  }
}


// ---- Cities and Attractions Classes ----  
float startingLong, startingLat, endingLong, endingLat;
String startingCity;
String endingCity;
//some global variables that we are going to use in the city class and attraction class

class City extends Location {
  //Constructor
  City(String n, float lat, float lon) {
    super(n, lat, lon);
  }
  //Methods
  void showOnMap() {
    //show the city on the screen
    cityMarker = loadImage("cityMarker.png");
    image(cityMarker, this.x, this.y, 30, 30);
    textFont(font);
    textAlign(CENTER);
    fill(255);
    text(this.name, this.x+20, this.y);
  }
}


class attractions extends Location {
  //Fields
  int budget;
  float rating;
  String category;
  boolean inRange, food, touristHotspot, nature, museum;
  
  //Constructor
  attractions(String n, float r, float lat, float lon, String c, int b) {
    super(n, lat, lon);
    this.rating = r;
    this.category = c;
    this.budget = b;
    this.inRange = false;
  }

  //Methods
  void checkInRange() { //check if the function is in range 
    this.inRange = true;
  }

   void showOnMap() { //show all markers on map, based off the display scale so the markers are a consisenet size
   //throughout scaling 
    attractionMarker = loadImage("attractionMarker.png");
    image(attractionMarker, this.x, this.y, 30/displayScale, 30/displayScale); //load the attraction marker
    textSize(15/displayScale); //scale the textsize to the zoom
    text(this.name, this.x+20/displayScale, this.y); //display text 
  }
}
