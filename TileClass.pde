String tileCache = "tilestorage";

class Tile {
  PImage tileImg;
  PVector locationProcessing, tileLocation; //tracks the 
  //processing coodernates and locks it into one class 
  Boolean loaded = false; //is not true, and the tile is the processing range 
  float size = 255; //sizes of the tile, detrmine by zoom and change by it
  boolean failed = false; //if there is a bad server request
  boolean stored = false; //flag if the cache is stored in memory 
 
  
  Tile(PVector TL) {
    this.tileLocation = TL;
  }

//-----------------------STORAGE IN MEMORY----------------------|
  PImage loadTileFromCache(tileMap t) {
    
    if (!checkIfOutside) {
    String path = sketchPath(tileCache + "/" + t.currentZoom + "/" + x + "/" + y + ".png");
    File f = new File(path);

    if (f.exists()) {
      return loadImage(path);
    }
    return null;
    }
    
    else {
      deleteTileCache();
    }
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
  
  void deleteTileCache() {
  // get sketch path
  String path = sketchPath(tileCache + "/" + zoom + "/" + x + "/" + y + ".png");

  File f = new File(path);

  // If it exists, delete it
  if (f.exists()) {
    boolean success = f.delete();
    if (!success) {
      println("Failed to delete tile cache: " + path);
    } else {
      println("Deleted tile cache: " + path);
    }
  } else {
    println("Tile not in cache: " + path);
  }
  }
  
 
 
 
//----------------------------REQUESTING FROM SERVER--------------------|
 
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
 
//---------------------------DRAWING TILES--------------------------------|

   boolean checkIfOutside(TileMap t) {
     int[] boundingBox = t.calcalculateSeen();
     float minTileX = boundingBox[0];
     float maxTileX = boundingBox[1];
     float minTileY = boundingBox[2];
     float maxTileY = boundingBox[3];
     
     return (tileLocation.x < minTileX || tileLocation.x > maxTileX || tileLocation.y < minTileY || tileLocation.y <maxTileY);
     
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
  
  void update() { //based off dragging and offset
    locationProcessing.x = this.tileLocation.x +  xOffSet;
    locationProcessing.y  = this.tileLocation.y +  yOffSet;
    
    
  
    this.drawTile();
  } 
  
  
}
