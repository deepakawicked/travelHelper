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

  // iterate backwards to safely remove items
    for (int i = tiles.size() - 1; i >= 0; i--) {
      Tile t = tiles.get(i);

      int tileX = (int)t.tileLocation.x;
      int tileY = (int)t.tileLocation.y;

    // if outside the visible tile bounds
      if (tileX < minTileX || tileX > maxTileX || tileY < minTileY || tileY > maxTileY) {
        // remove from list
        tiles.remove(i);

        // free memory
        t.tileImg = null;

        // optionally delete from disk cache
        String path = sketchPath(tileCache + "/" + currentZoom + "/" + tileX + "/" + tileY + ".png");
        File f = new File(path);
        if (f.exists()) {
          f.delete();
        }
      }
    }
  }

  
  void drawTiles()  { //draw the full tile set 
    for(int i = 0; i < tiles.get(); i++) {
       Tile tL = tiles.get(i);
       
       tl.drawTile();
       tL.updatePos();
    }
  
  }

}
