class TileMap {
  ArrayList<Tile> tiles;
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

  int[] calculateVisibleTiles(float xOff, float yOff) {
    float left = -xOff;
    float top = -yOff;
    float right = left + width;
    float bottom = top + height;

    int minX = max(floor(left / tileSize), floor(longToXTile(minLon, currentZoom)));
    int maxX = min(ceil(right / tileSize), ceil(longToXTile(maxLon, currentZoom)));
    int minY = max(floor(top / tileSize), floor(latToYTile(maxLat, currentZoom)));
    int maxY = min(ceil(bottom / tileSize), ceil(latToYTile(minLat, currentZoom)));

    return new int[]{minX, maxX, minY, maxY};
  }

  void update(float xOff, float yOff) {
    int[] bounds = calculateVisibleTiles(xOff, yOff);
    int minX = bounds[0], maxX = bounds[1], minY = bounds[2], maxY = bounds[3];

    for (int x = minX; x <= maxX; x++) {
      for (int y = minY; y <= maxY; y++) {
        if (!tileExists(x, y)) tiles.add(new Tile(x, y, currentZoom));
      }
    }

    tiles.removeIf(t -> t.tx < minX || t.tx > maxX || t.ty < minY || t.ty > maxY);

    for (Tile t : tiles) t.update(xOff, yOff);
  }

  void drawTiles() {
    for (Tile t : tiles) t.drawTile();
  }

  boolean tileExists(int x, int y) {
    for (Tile t : tiles) if (t.tx == x && t.ty == y) return true;
    return false;
  }
}

class Tile {
  PImage img;
  int tx, ty, zoom;
  float screenX, screenY;
  boolean loaded = false, failed = false;
  float alpha = 0;

  Tile(int tx, int ty, int zoom) {
    this.tx = tx;
    this.ty = ty;
    this.zoom = zoom;
    loadTile();
  }

  void loadTile() {
    String path = sketchPath("tilestorage/" + zoom + "/" + tx + "/" + ty + ".png");
    File f = new File(path);
    if (f.exists()) {
      img = loadImage(path);
      loaded = img != null;
    } else {
      try {
        img = loadImage("https://api.maptiler.com/maps/streets-v4/" + zoom + "/" + tx + "/" + ty + ".png?key=" + apiKey);
        loaded = true;
        saveTileToCache();
      } catch (Exception e) {
        failed = true;
      }
    }
  }

  void saveTileToCache() {
    String folderPath = sketchPath("tilestorage/" + zoom + "/" + tx);
    File folder = new File(folderPath);
    if (!folder.exists()) folder.mkdirs();
    if (img != null) img.save(folderPath + "/" + ty + ".png");
  }

  void update(float xOff, float yOff) {
    float targetX = tx * tileSize + xOff;
    float targetY = ty * tileSize + yOff;
    screenX += (targetX - screenX) * 0.25;
    screenY += (targetY - screenY) * 0.25;
    if (loaded) alpha += (255 - alpha) * 0.1;
    alpha = constrain(alpha, 0, 255);
  }

  void drawTile() {
    if (loaded && img != null) tint(255, alpha);
    if (loaded && img != null) image(img, screenX, screenY, tileSize, tileSize);
    else if (failed) { fill(255, 0, 0); rect(screenX, screenY, tileSize, tileSize); }
    else { fill(200); rect(screenX, screenY, tileSize, tileSize); }
    noTint();
  }
}
