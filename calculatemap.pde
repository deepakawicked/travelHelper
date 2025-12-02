//loading: world cooders --> mercator projecitons --> x,y processng oswa

//when requesting: 
//this script exists to pull the map tiles
int mincurrentZoom = 6;
int maxcurrentZoom = 10; 
int currentcurrentZoom = mincurrentZoom;
boolean currentZooming = true;;



PImage getTile(int x, int y, int currentZoom) {//request tiles from mapTiler or other backup options 
   return loadImage(
} 




void drawTiles() {

   //convert based on world coodernates 
  int visibleXMin = floor(-xOffSet / tileSize);
  int visibleXMax = floor((-xOffSet + width) / tileSize);
  int visibleYMin = floor(-yOffSet / tileSize);
  int visibleYMax = floor((-yOffSet + height) / tileSize);
  
  //go through visable tiles 
  for (int x = visibleXMin; x <= visibleXMax; x++) {
    for (int y = visibleYMin; y <= visibleYMax; y++) {

      // Clamp to allowed region
      if (x < allowedXMin || x > allowedXMax || y < allowedYMin || y > allowedYMax) {
        fill(255); 
        noStroke();
        rect(tileToWorldX(x) + xOffSet, tileToWorldY(y) + yOffSet, tileSize, tileSize); // white placeholder
        continue;
      }

      // Request tile
      String url = "https://api.maptiler.com/maps/streets-v4/" + currentcurrentZoom + "/" + x + "/" + y + ".png?key=" + apiKey;
      PImage tile = loadImage(url);

      // Draw tile at world coords + offset
      image(tile, tileToWorldX(x) + xOffSet, tileToWorldY(y) + yOffSet, tileSize, tileSize);
    }
  }
}
