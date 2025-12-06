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
