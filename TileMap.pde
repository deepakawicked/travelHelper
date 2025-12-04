class TileMap {
  ArrayList<Tile> tiles;
  int currentZoom, minZoom, maxZoom;
  float minLat, maxLat, minLon, maxLon; //these values will be pluged in
  float scale; //scale the tiles smoothly between requests

  
  TileMap(float mlat, float mxlat, float mlon, float mxlon, int cZ, int minZ, int maxZ) { //defines the bounding box
  //(Feededing in queebec and ontario)
    this.minLat = mlat;
    this.maxLat = mxlat;
    this.minLon = mlon;
    this.maxLon = mxlon;
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

  void createTiles() {
    for(int x = 0; x < tiles.size(); x++) {
      for (int y = 0; y < tiles.size(); x++) {
      
      }
    
    }
    
  }
    
     
 void drawTiles() {
  for (Tile t : tiles) {
    t.updatePos(); // update screen position based on offsets
    t.drawTile();  // draw the tile
  }
 }
