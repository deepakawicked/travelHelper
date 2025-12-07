class TileMap {
  
  //fields
  ArrayList<Tile> tiles; //tracks the only visible tiles 
  int currentZoom, minZoom, maxZoom; //clamp to zooms. Can simulate different 
  //maps with zoom levels if wanted 
  float minLat, maxLat, minLon, maxLon; //bounding box for tiles requested 


  //constructor, used once 
  TileMap(float mlat, float mxlat, float mlon, float mxlon, int cZ, int minZ, int maxZ) {
    minLat = mlat;
    maxLat = mxlat;
    minLon = mlon;
    maxLon = mxlon;
    currentZoom = cZ;
    minZoom = minZ;
    maxZoom = maxZ;
    tiles = new ArrayList<Tile>();
  }

  int[] calculateSeen(float xOff, float yOff) {
    //calculate the bounding box of the screen visable
    
    //world coodernate of processing 
    float left = -xOff;
    float top = -yOff;
    float right = left + width;
    float bottom = top + height;

    //convert to tile Web Mercator Slippy Tile System. Floor and extend out
    //as XYZ must be integers. Calculates the tile visable in the camera view./
    int minTileX = floor(left / tileSize);
    int maxTileX = floor(right / tileSize);
    int minTileY = floor(top / tileSize);
    int maxTileY = floor(bottom / tileSize);
    
    //clamps and prevents invalid tile requests (reinforces the bounding box set 
    //ontario and quebec)
    minTileX = max(minTileX, floor(longToXTile(minLon, currentZoom)));
    maxTileX = min(maxTileX, ceil(longToXTile(maxLon, currentZoom)));
    minTileY = max(minTileY, floor(latToYTile(maxLat, currentZoom)));
    maxTileY = min(maxTileY, ceil(latToYTile(minLat, currentZoom)));

    return new int[]{minTileX, maxTileX, minTileY, maxTileY};
  }

  void update(float xOff, float yOff) {
   
    int[] bounds = calculateSeen(xOff, yOff); //feed in the offset determined
    // by the mouseMovement
    
    //gets the Mercator slippy tile bounds  
    int minX = bounds[0];
    int maxX = bounds[1];
    int minY = bounds[2];
    int maxY = bounds[3];

    // spawn missing tiles. Loop through every spot where a tile shoot be visible
    for (int x = minX; x <= maxX; x++) {
      for (int y = minY; y <= maxY; y++) {

        if (!tileExists(x, y)) spawnTile(x, y);//if it isn't loaded, create it.
      }
    }

    // remove tiles outside visible range, remoivng it backwards to prevent skipping 
    // and nullPointerExceptions.
    for (int i = tiles.size() - 1; i >= 0; i--) {
      Tile t = tiles.get(i);
      if (t.tx < minX || t.tx > maxX || t.ty < minY || t.ty > maxY) {
        tiles.remove(i); //remove it it goeso ut of bounds 
      }
    }

    // update tile screen positions, applying mouseDrag offset 
    for (Tile t : tiles) t.update(xOff, yOff);
  }

  void drawTiles() {
    for (Tile t : tiles) t.drawTile(); //draw all the tiles in the list
  }

  boolean tileExists(int x, int y) {
  for (Tile t : tiles) {
    if (t.tx == x && t.ty == y) return true;
  }
    return false;
  }
  
  
  void spawnTile(int x, int y) {
    println("Spawning tile at: " + x + "," + y + " zoom: " + currentZoom);
    //create a new til
    Tile t = new Tile(x, y);

    t.tileImg = t.loadTileFromCache(this);//load from the cache (the img)
    
    if (t.tileImg == null) t.tileImg = t.requestTile(this); // if there is not img, get from API
    if (t.tileImg != null && t.loaded) t.saveTileToCache(this); // if there is an image, and the image is LOADED
    //save to memory 

    tiles.add(t); //add tile to visible tile list 
  }
}

//-TILE CLASS------------------------

class Tile {
  
  //fields 
  PImage tileImg;
  int tx, ty;//tile coodernate
  float screenX, screenY; //processing coodinates 
  boolean loaded = false;
  boolean failed = false; //replacement tiles for when the API fails to call

  Tile(int x, int y) { //used in the creaion of new tiles 
    tx = x;
    ty = y;
  }

  void update(float xOff, float yOff) {
    
    //println("The current tile zoom is: " + t.currentZoom);
    //add the offset from the mouseDrag into the tiles.
    //all tiles move, so it looks like a moving screen rather than one tile 
    //moving
    screenX = tx * tileSize + xOff;
    screenY = ty * tileSize + yOff;
  }

  void drawTile() {
    if (loaded && tileImg != null) { //if sucessful
      image(tileImg, screenX, screenY, tileSize, tileSize);
    } else if (failed) {
      fill(255, 0, 0); //if the tilefailed to pull from an API
      rect(screenX, screenY, tileSize, tileSize);
    } else {
      fill(200); //default tile if it hasn't loaded yet
      rect(screenX, screenY, tileSize, tileSize);
    }
  }

  PImage loadTileFromCache(TileMap t) {
    
    //create the path for loading rom the cache (tilestorage folder)
    String path = sketchPath("tilestorage/" + t.currentZoom + "/" + this.tx + "/" + this.ty + ".png");
    
    //creates a new file. This is not a processing orginal method, but 
    //part of the oracle JAVA documentaiton 
    File f = new File(path);
    if (f.exists()) { //boolean value which checks if the img exists 
      PImage img = loadImage(path); //loads then 
      if (img != null) { // if we do, load, set the filed tileImg to this and display
        tileImg = img;
        loaded = true;
        return img; //close 
      }
    }
    return null; //if nothing happens, do nothing until the cache/memory is requested
  }

  void saveTileToCache(TileMap t) {
    
    String base = sketchPath("tilestorage/" + t.currentZoom + "/" + this.tx); //creating a folder 
    //per each zoom, and it's x value on the tile system
    File folder = new File(base); //setting a file function
    
    if (!folder.exists()) folder.mkdirs(); //if the zoom folder doesn't exist, create
    //the folder and all parentfolders (tileStorage)
    
    if (tileImg != null) tileImg.save(base + "/" + ty + ".png"); //if we do not have 
    //an assigned value for the cache, set the TileImg to this
  }

  PImage requestTile(TileMap t) { //request a tile from the server provider (API)
    try { // to prevent tons of errors if there is the end of the provider,
    //try intead of hrdcoding 
      //most common notation, uses the fields in it's own tile class
      String url = "https://api.maptiler.com/maps/streets-v4/" + t.currentZoom + "/" + this.tx + "/" + this.ty + ".png?key=" + apiKey;
      PImage img = loadImage(url);
      tileImg = img;
      loaded = true;
      
      //send the img to the TileMap class to be saved
      return img;
    } catch (Exception e) {
      println("Failed to load tile: " + this.tx + "," + this.ty + " " + e.getMessage());
      failed = true;
      return null; //break out of function 
    }
  }
}
