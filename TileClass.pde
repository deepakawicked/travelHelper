class Tile {
  PImage tileImg;
  PVector locationProcessing, TileLocation, RealCoods; //tracks the 
  //processing coodernates and locks it into one class 
  Boolean loaded = false; //is not true, and the tile is the processing range 
  float size; //sizes of the tile, detrmine by zoom and change by it
  boolean failed = false; //if there is a bad server request
  
  Tile(PVector TL) {
    this.TileLocation = TL;
  }
  
  void requestTile(int x, int y, int zoom)  {
      // in them meantime. It replaces the empty squares with a white 
    
    try {
  //store the request from the API (mapTiler)
    String url = "https://api.maptiler.com/maps/streets-v4/" + zoom + "/" + x + "/" + y 
             + ".png?key=" + apiKey;
             
    this.tileImg = loadImage(url);
    loaded = true;
    }
    
    catch(Exception e) {
       println("Failed to load tile at " + x + "," + y + ": " + e.getMessage());
       failed = true;
    }
  
  }
  
  //add implemention for using the cache only 
  void drawTile(int x, int y, int zoom) { // draw the tile as first --> This functions draws the white and wiats fro the request to come through

    if (loaded && tileImg != null) { //if the request is good, draw the map
      image(tileImg, locationProcessing.x, locationProcessing.y, size, size);
    
    } else if (failed) {
      fill(255,0,0);//red box for failed tiles
      noStroke();
      rect(locationProcessing.x, locationProcessing.y, size, size);
    
    } else {
      //placeholder if no internet or intenret is slow 
      fill(255);
      noStroke();
      rect(locationProcessing.x, locationProcessing.y,  size, size);
    
    }
  
  }
  
  void updatePos() { //based off dragging and offset
  
  
  } 
  
  
}
