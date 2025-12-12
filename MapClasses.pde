class TileMap { // the "manger" of the Tile Class. Handles the generation of what tiles are present 
  ArrayList<Tile> tiles; //keeps tracks of what tiles are present in the program window.
  int currentZoom, minZoom, maxZoom;
  float minLat, maxLat, minLon, maxLon;

  TileMap(float minLat, float maxLat, float minLon, float maxLon, int startZoom, int minZ, int maxZ) {
    this.minLat = minLat;
    this.maxLat = maxLat;
    this.minLon = minLon;
    this.maxLon = maxLon;
    this.currentZoom = startZoom;
    this.minZoom = minZ;
    this.maxZoom = maxZ;
    tiles = new ArrayList<Tile>();
  }

  //determines which tile indicies should be visible given the camera offset and current positon of the widnwo)
  int[] calculateVisibleTiles(float xOff, float yOff) {
    float left = -xOff;
    float top = -yOff;
    float right = left + width;
    float bottom = top + height;

    //clamp TILE RANGE to map boundaries (prevents the generation of tiles OUTSIDE of Quebec and Ontario)
    int minX = max(floor(left / tileSize), floor(longToXTile(minLon, currentZoom)));
    int maxX = min(ceil(right / tileSize), ceil(longToXTile(maxLon, currentZoom)));
    int minY = max(floor(top / tileSize), floor(latToYTile(maxLat, currentZoom)));
    int maxY = min(ceil(bottom / tileSize), ceil(latToYTile(minLat, currentZoom)));

    return new int[]{minX, maxX, minY, maxY};
  }
  
  ///load any new tiles entering the view, unload tiles leaving the view, and update hte positon of all tiles 
  //all tiles are updated constantly, create a view as if the view is navigating a map themselves, while the map is truly movign 
  void update(float xOff, float yOff) {
    int[] bounds = calculateVisibleTiles(xOff, yOff);
    int minX = bounds[0], maxX = bounds[1], minY = bounds[2], maxY = bounds[3]; //recive the boundary condtions 

    //add mising tiles inside the visible range (using the WEB MERCATOR TILE SYSTEM
    for (int x = minX; x <= maxX; x++) {
      for (int y = minY; y <= maxY; y++) {
        if (!tileExists(x, y)) tiles.add(new Tile(x, y, currentZoom));
      }
    }

    for (int i = tiles.size() - 1; i >= 0; i--) {
      Tile t = tiles.get(i);
      if (t.tx < minX || t.tx > maxX || t.ty < minY || t.ty > maxY) { //remove tiles if they go out of bounds 
      tiles.remove(i);
      }
  }

    for (Tile t : tiles) t.update(xOff, yOff); //update the position based on the offset 
  }

  void drawTiles() { // draw all active tiles 
    for (Tile t : tiles) t.drawTile();
  }

  //check if a tile is already loaded (used in the creation and addition of tiles to a list)
  boolean tileExists(int x, int y) {
    for (Tile t : tiles) if (t.tx == x && t.ty == y) return true;
    return false;
  }
}

class Tile { //each tile handles it's own image, positon, and is reposible for tracking and recieving from mapTiler 
  PImage img;
  int tx, ty, zoom;
  float screenX, screenY;
  boolean loaded = false, failed = false;
  float alpha = 0; //fade in amount (for smooth tile generation animation)

  Tile(int tx, int ty, int zoom) {
    this.tx = tx;
    this.ty = ty;
    this.zoom = zoom;
    loadTile();
  }

  //load tile from Cache, if missing, fetch from MapTiler and cache it 
  void loadTile() {
    
    String path = sketchPath("tilestorage/" + zoom + "/" + tx + "/" + ty + ".png"); //find the file path (or sketchpath)
    File f = new File(path); //new file (these are JAVA functions, not orignal to processing, can be found in the 
    //oracle documention)
    
    if (f.exists()) { //check if the file exists 
      img = loadImage(path); //load the image from the path
      if (img == null) {
        loaded = false;
      }  else {
        loaded = true;
      }
    } else {
      
        try { //try to request from the MapTiler with the data if not present in the cache 
          
          img = loadImage("https://api.maptiler.com/maps/streets-v4/" + zoom + "/" + tx + "/" + ty + ".png?key=" + apiKey); 
          loaded = true;
          saveTileToCache(); //save the tile to memory after fetchng 
          
          
      } catch (Exception e) { //if the Tile does not load, do not fetch 
        failed = true; //allows for red tiles, which notifys to the user it was unable to load 
      }
    }
  }
  //ensures downloaded tiles are stores locally so future loads don't require network acess 
  void saveTileToCache() {
    String folderPath = sketchPath("tilestorage/" + zoom + "/" + tx);
    File folder = new File(folderPath);
    
    //create the folder does not exists 
    if (!folder.exists()) folder.mkdirs(); //creates "tilestorage, "tilestorage/zoom", and "tilestorage/zoom/txif needed 
    
    //save the tile image as ty.png only if it was sucessfully loaded (prevents errors or trying to save
    //"empty" image 
    if (img != null) img.save(folderPath + "/" + ty + ".png");
    
  }

  //smoothly moves the tiles to its correct on screen postions and fades it in 
  void update(float xOff, float yOff) {
    
    float targetX = tx * tileSize + xOff;
    float targetY = ty * tileSize + yOff;
    
    //animate movement, approaching the target graudauly for smooth sliding 
    screenX += (targetX - screenX) * 0.25;
    screenY += (targetY - screenY) * 0.25;
    
    //increase the fade only if the tile is loaded 
    if (loaded) alpha += (255 - alpha) * 0.1;
    
    //keep the fade-in with valid range 
    alpha = constrain(alpha, 0, 255);
  }

  //renders the tile image if loaded, or a placeholder if loading failed (grey boxes seen)
  void drawTile() {
    if (loaded && img != null) {
      
      tint(255, alpha); //draw the image with the correct fade in value for fadein 
      image(img, screenX, screenY, tileSize, tileSize); //load in the image, might not be shown at first due to the
      //fade in value 
    
    }
    else if (failed) { 
      fill(255, 0, 0); rect(screenX, screenY, tileSize, tileSize); 
    } else { 
      
        fill(200); 
        rect(screenX, screenY, tileSize, tileSize); //draw a red place holder while loading if it fails
    } 
    //never is called due to all tiles being present in memroy 
    
    //resets the tint (fade) so it does not affect other drawing 
    noTint();
  }
}
