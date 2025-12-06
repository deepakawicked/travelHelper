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
