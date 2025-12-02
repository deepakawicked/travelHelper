//loading: world cooders --> mercator projecitons --> x,y processng oswa

//when requesting: 
//this script exists to pull the map tiles
int minZoom = 6;
int maxZoom = 10; 
int currentZoom = minZoom;
boolean currentZooming = true;;







void drawTiles() {

  // 1. Compute visible tile range based on scroll offset
  int visibleXMin = floor(-xOffSet / tileSize);
  int visibleXMax = floor((-xOffSet + width) / tileSize);
  int visibleYMin = floor(-yOffSet / tileSize);
  int visibleYMax = floor((-yOffSet + height) / tileSize);

  for (int x = visibleXMin; x <= visibleXMax; x++) {
    for (int y = visibleYMin; y <= visibleYMax; y++) {

      // Skip impossible indexes
      if (x < 0 || y < 0) continue;

      // WORLD POSITION to draw tile
      float drawX = x * tileSize + xOffSet;
      float drawY = y * tileSize + yOffSet;

      // 2. Check bounding box BEFORE requesting tile
      if (x < allowedXMin || x > allowedXMax || y < allowedYMin || y > allowedYMax) {
        // draw placeholder OUTSIDE region
        fill(255);
        noStroke();
        rect(drawX, drawY, tileSize, tileSize);
        continue;
      }

      // 3. Request tile (temporary — add cache later)
      String url = "https://api.maptiler.com/maps/streets-v2/" +
                   currentZoom + "/" + x + "/" + y +
                   ".png?key=" + apiKey;

      PImage t = loadImage(url);

      if (t != null) image(t, drawX, drawY, tileSize, tileSize);
    }
  }
}
