class Tile {
  PVector locationProcessing, TileLocation, RealCoods; //tracks the 
  //processing coodernates and locks it into one class 
  Boolean loaded = false; //is not true, and the tile is the processing range 
  
  Tile(PVector TL) {
    this.TileLocation = TL;
  }
  
  void requestTile(int x, int y, int zoom)  {
    
  
  }
  
  void drawTile() { // draw the tile as first --> This functions draws the white and wiats fro the request to come through
  // in them meantime. It replaces the empty squares with a white 
  }
  
  void updatePos() { //based off dragging and offset
  
  
  } 
  
  void deleteTile() { //delete the tile from meory if need, and deleted from cache (temp memory)
  
  
  }
  
}
