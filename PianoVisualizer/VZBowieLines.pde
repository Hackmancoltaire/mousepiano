class VZBowieLines extends Visualizer {
  public VIBowieWave[] visualItems = new VIBowieWave[88];

  float waveWidth;
  boolean setup = false;
  //File imageDir;

  VZBowieLines(int[] colorSet) {
    // Get images from the bowie folder
    //  imageDir = new File(dataPath("bowie"));
    //images = dir.list();
    //
    //  	if (imageDir == null) {
    //  	  println("Bowie folder does not exist or cannot be accessed.");
    //  	}

    float increment = screenWidth / keys;
    color startColor = colorSet[0];
    color endColor = colorSet[1];

    for (int i=0; i < keys; i++) {
      visualItems[i] = new VIBowieWave(increment*i, increment, lerpColor(startColor, endColor, 0.01 * i));
    }

    setup = true;
  }

  void update() {
    for (int i=0; i < keys; i++) {
      if (visualItems[i] != null) {
        visualItems[i].update();
      }
    }
  }

  void ping(int itemId, int velocity) {
    visualItems[itemId].ping();
  }

  void pong(int itemId) {
  }
}

// class VIBowieImage extends VisualItem {
// 	PImage img;
// 	float opacity;
//
// 	VIBowieImage(String imageName) {
// 		img = loadImage(dataPath("bowie") + "/" + imageName);
//
// 	}
//
// }

class VIBowieWave extends VisualItem {
  float prevX=0.0, prevY=0.0;
  int numOfWaves = 0;
  float angle = 0;
  float waveWidth;

  float startX = 0;
  float strokeWeight = 1.5;

  VIBowieWave(float myStartX, float width, color myColor) {
    itemColor = myColor;
    startX = myStartX;
    waveWidth = width;
  }

  void update() {
    stroke(itemColor);
    strokeWeight(strokeWeight);

    pushMatrix();
    translate(startX + (waveWidth/2), 0);

    for (int count=0; count < screenHeight; ++count) {
      y = count;

      angle = radians(count);
      x = sin(angle*(numOfWaves/2.0));
      x = x * lerp(1, 0, count/float(screenHeight/2));
      x = map(x, -1, 1, -waveWidth/2, waveWidth/2);

      if (numOfWaves > 0) {
        line(prevX, prevY, x, y);
      }

      prevX = x;
      prevY = y;
    }

    prevX = prevY = 0.0;
    popMatrix();

    if (numOfWaves > 0) {
      numOfWaves--;
    }
  }

  void ping() {
    numOfWaves += 10;
  }
}
