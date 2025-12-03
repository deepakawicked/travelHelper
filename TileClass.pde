String tileCache = "tilestorage";

class Tile {
  PImage tileImg;
  PVector locationProcessing, tileLocation, RealCoods; //tracks the 
  //processing coodernates and locks it into one class 
  Boolean loaded = false; //is not true, and the tile is the processing range 
  float size; //sizes of the tile, detrmine by zoom and change by it
  boolean failed = false; //if there is a bad server request
  boolean stored = false; //flag if the cache is stored in memory 
  
  Tile(PVector TL) {
    this.tileLocation = TL;
  }
  
  PImage loadTileFromCache(int x, int y, int zoom) {
    String path = sketchPath(tileCache + "/" + zoom + "/" + x + "/" + y + ".png");
    File f = new File(path);

    if (f.exists()) {
      return loadImage(path);
    }
    return null;
  }
  
  
  void saveTileToCache(int x, int y, int zoom, PImage img) {
    String base = sketchPath(tileCache +"/" + zoom + "/" + x);
    File folder = new File(base);
    
    if (!folder.exists()) {
      folder.mkdirs();
    }
    
    String tilePath = base + "/" + y + ".png";
    img.save(tilePath);
  
  }
  
  PImage requestTile(int x, int y, int zoom)  {
      // in them meantime. It replaces the empty squares with a white 
    
    try {
  //store the request from the API (mapTiler)
    String url = "https://api.maptiler.com/maps/streets-v4/" + zoom + "/" + x + "/" + y 
             + ".png?key=" + apiKey;
             
    PImage tileImg = loadImage(url);
    loaded = true;
    
    return tileImg;
    
    }
    catch(Exception e) {
       println("Failed to load tile at " + x + "," + y + ": " + e.getMessage());
       failed = true;
       return null;
    }
  
  }
  
  //add implemention for using the cache after a tile is downloased 
  void drawTile() { // draw the tile as first --> This functions draws the white and wiats fro the request to come through

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
    locationProcessing.x = this.tileLocation.x +  xOffSet;
    locationProcessing.y  = this.tileLocation.y +  yOffSet;
  
  } 
  
  
}
