class TileMap {
  ArrayList<Tile> tiles;
  int currentZoom, minZoom, maxZoom;
  float minLat, maxLat, minLon, maxLon;
  float tileSize = 256;

  TileMap(float mlat, float mxlat, float mlon, float mxlon, int cZ, int minZ, int maxZ) {
    minLat = mlat;
    maxLat = mxlat;
    minLon = mlon;
    maxLon = mxlon;
    currentZoom = cZ;
    minZoom = minZ;
    maxZoom = maxZ;
    tiles = new ArrayList<Tile>();
  }

  int[] calculateSeen(float xOff, float yOff) {
    float left = -xOff;
    float top = -yOff;
    float right = left + width;
    float bottom = top + height;

    int minTileX = floor(left / tileSize);
    int maxTileX = floor(right / tileSize);
    int minTileY = floor(top / tileSize);
    int maxTileY = floor(bottom / tileSize);

    minTileX = max(minTileX, floor(longToXTile(minLon, currentZoom)));
    maxTileX = min(maxTileX, ceil(longToXTile(maxLon, currentZoom)));
    minTileY = max(minTileY, floor(latToYTile(maxLat, currentZoom)));
    maxTileY = min(maxTileY, ceil(latToYTile(minLat, currentZoom)));

    return new int[]{minTileX, maxTileX, minTileY, maxTileY};
  }

  void update(float xOff, float yOff) {
    int[] bounds = calculateSeen(xOff, yOff);
    int minX = bounds[0];
    int maxX = bounds[1];
    int minY = bounds[2];
    int maxY = bounds[3];

    // spawn missing tiles
    for (int x = minX; x <= maxX; x++) {
      for (int y = minY; y <= maxY; y++) {
        if (!tileExists(x, y, currentZoom)) spawnTile(x, y);
      }
    }

    // remove tiles outside visible range
    tiles.removeIf(t -> t.tx < minX || t.tx > maxX || t.ty < minY || t.ty > maxY);

    // update tile screen positions
    for (Tile t : tiles) t.update(xOff, yOff);
  }

  void drawTiles() {
    for (Tile t : tiles) t.drawTile();
  }

  boolean tileExists(int x, int y, int zoom) {
    for (Tile t : tiles) {
      if (t.tx == x && t.ty == y && t.zoom == zoom) return true;
    }
    return false;
  }

  void spawnTile(int x, int y) {
    Tile t = new Tile(x, y, currentZoom);

    t.tileImg = t.loadTileFromCache();
    if (t.tileImg == null) t.tileImg = t.requestTile();
    if (t.tileImg != null && t.loaded) t.saveTileToCache();

    tiles.add(t);
  }
}
