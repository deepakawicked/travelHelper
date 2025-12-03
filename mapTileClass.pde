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
  
  void calculateSeen() {
    
    float xMaxSeen;
    float yMinSeen;
    float xMaxSeen;
    float yMaxSeen;
    
    for (int i = 0; i < tiles.size(); i++) {
      Tile currentCheck = tiles.get(i);
      
      //delete from cache (call cache manager function)
    
    }
    
    
    
  
  }
  
  void updateTileCache() { //update from catch
    
  }
  
  void drawTiles()  { //draw the full tile set 
  
  
  }

}
