class TileMap {
  ArrayList<Tile> tiles;
  int currentZoom, minZoom, maxZoom;
  float minLat, maxLat, minLon, maxLon; //these values will be pluged in
  float scale; //scale the tiles smoothly between requests
  
  TileMap(float mlat, float mxlat, float mlon, float mxlon) { //defines the bounding box
  //(Feededing in queebec and ontario)
    this.minLat = mlat;
    this.maxLat = mxlat;
    this.minLon = mlon;
    this.maxLon = mxlon;
  
  }
  
  TileMap(int cZ, int minZ, int maxZ) { //assigning zoom. only used one during setup
    this.currentZoom = cZ;
    this.minZoom = minZ;
    this.maxZoom = maxZ;
  }
  
int[] calculateSeen() {
  // screen bounds in "world pixels"
  float left = -xOffSet;
  float top = -yOffSet;
  float right = left + width;
  float bottom = top + height;

  // convert bounding box of screen into tile coordinates
  int minTileX = floor(left / tileSize);
  int maxTileX = floor(right / tileSize);
  int minTileY = floor(top / tileSize);
  int maxTileY = floor(bottom / tileSize);

  // clamp to the allowed region (min/max lat/lon)
  minTileX = max(minTileX, floor(longToXTile(minLon)));
  maxTileX = min(maxTileX, ceil(longToXTile(maxLon)));
  minTileY = max(minTileY, floor(latToYTile(maxLat)));
  maxTileY = min(maxTileY, ceil(latToYTile(minLat)));
  int[] clampLst = {minTileX, maxTileX, minTileY, maxTileY};
  return clampLst;
}
    
    
  
  }
  
  void updateTileCache() {
    int[] bounds = calculateSeen();
    int minTileX = bounds[0];
    int maxTileX = bounds[1];
    int minTileY = bounds[2];
    int maxTileY = bounds[3];

  // Remove tiles out of bounds
  for (int i = tiles.size()-1; i >= 0; i--) {
    Tile t = tiles.get(i);
    int tileX = (int)t.tileLocation.x;
    int tileY = (int)t.tileLocation.y;

    if (tileX < minTileX || tileX > maxTileX || tileY < minTileY || tileY > maxTileY) {
      tiles.remove(i);
      t.tileImg = null; // free memory

      // Delete from disk if needed
      String path = sketchPath(tileCache + "/" + currentZoom + "/" + tileX + "/" + tileY + ".png");
      File f = new File(path);
      if (f.exists()) f.delete();
    }
  }

  // Add missing tiles
  for (int x = minTileX; x <= maxTileX; x++) {
    for (int y = minTileY; y <= maxTileY; y++) {
      boolean exists = false;
      for (Tile t : tiles) {
        if ((int)t.tileLocation.x == x && (int)t.tileLocation.y == y) {
          exists = true;
          break;
        }
      }

      if (!exists) {
        PVector loc = new PVector(x, y); // store tile coordinates
        Tile newTile = new Tile(loc);

        // Try loading from cache first
        newTile.tileImg = newTile.loadTileFromCache(x, y, currentZoom);

        // If cache missing, request from API
        if (newTile.tileImg == null) {
          newTile.tileImg = newTile.requestTile(x, y, currentZoom);
          if (newTile.tileImg != null) {
            newTile.saveTileToCache(x, y, currentZoom, newTile.tileImg);
          }
        }

        tiles.add(newTile);
      }
    }
  }
  }


  
 void drawTiles() {
  for (Tile t : tiles) {
    t.updatePos(); // update screen position based on offsets
    t.drawTile();  // draw the tile
  }
 }
