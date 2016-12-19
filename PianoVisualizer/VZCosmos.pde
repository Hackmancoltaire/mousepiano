class VZCosmos extends Visualizer {
  PImage backgroundImg;
  int active;
  int lastActive;

  VZCosmos() {
    active = lastActive = 0;
    backgroundImg = loadImage(dataPath("images") + "/cosmos35.jpg");
  }

  void clear(int visualizerId) {
  }

  void update() {
    noTint();
    colorMode(RGB, 255);
    noStroke();
    //translate(0, -270);
    PImage tempSwatch;

    if (active > 0) {
      int swatchWidth = 150 * active;

      int randomX = floor(random(backgroundImg.width - swatchWidth));
      if (randomX < 0) {
        randomX = 0;
      }

      int randomY = floor(random(backgroundImg.height - screenHeight));
      if (randomY < 0) {
        randomY = 0;
      }

      //println("X: " + randomX + " Y: " + randomY);

      tempSwatch = backgroundImg.get(randomX, randomY, swatchWidth, screenHeight);

      copy(0, 0, screenWidth, screenHeight, (swatchWidth * -1), 0, screenWidth, screenHeight);
      image(tempSwatch, screenWidth - swatchWidth, 0);
      strokeWeight(4);
      stroke(color(0));
      noFill();
      rect(screenWidth-swatchWidth, -4, swatchWidth, screenHeight+4);

      active -= active;
    }
  }

  void ping(int itemId) {
    active++;
  }

  void pong(int itemId) {
  }
}