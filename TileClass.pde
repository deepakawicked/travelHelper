class Tile {
  PImage tileImg;
  int tx, ty, zoom;
  float screenX, screenY;
  boolean loaded = false;
  boolean failed = false;
  float size = 256;

  Tile(int x, int y, int z) {
    tx = x;
    ty = y;
    zoom = z;
  }

  void update(float xOff, float yOff) {
    screenX = tx * size + xOff;
    screenY = ty * size + yOff;
  }

  void drawTile() {
    if (loaded && tileImg != null) {
      image(tileImg, screenX, screenY, size, size);
    } else if (failed) {
      fill(255, 0, 0);
      rect(screenX, screenY, size, size);
    } else {
      fill(200);
      rect(screenX, screenY, size, size);
    }
  }

  PImage loadTileFromCache() {
    String path = sketchPath("tilestorage/" + zoom + "/" + tx + "/" + ty + ".png");
    File f = new File(path);
    if (f.exists()) {
      PImage img = loadImage(path);
      if (img != null) {
        tileImg = img;
        loaded = true;
        return img;
      }
    }
    return null;
  }

  void saveTileToCache() {
    String base = sketchPath("tilestorage/" + zoom + "/" + tx);
    File folder = new File(base);
    if (!folder.exists()) folder.mkdirs();
    if (tileImg != null) tileImg.save(base + "/" + ty + ".png");
  }

  PImage requestTile() {
    try {
      String url = "https://api.maptiler.com/maps/streets-v4/" + zoom + "/" + tx + "/" + ty + ".png?key=" + apiKey;
      PImage img = loadImage(url);
      tileImg = img;
      loaded = true;
      return img;
    } catch (Exception e) {
      println("Failed to load tile: " + tx + "," + ty + " " + e.getMessage());
      failed = true;
      return null;
    }
  }
}
