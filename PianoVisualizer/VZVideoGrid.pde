class VZVideoGrid extends Visualizer {

  VZVideoGrid(int[] colorSet, PApplet parent) {
    // Get images from the bowie folder
    //  imageDir = new File(dataPath("bowie"));
    //images = dir.list();
    //
    //  	if (imageDir == null) {
    //  	  println("Bowie folder does not exist or cannot be accessed.");
    //  	}

    color startColor = colorSet[0];
    color endColor = colorSet[1];

    background(0);

    for (int i=0; i < keys; i++) {
      visualItems[i] = new VZVideo(i, lerpColor(startColor, endColor, 0.01 * i), (dataPath("bowie/video") + "/blackstar.3gpp"), parent);
    }

    setup = true;
  }

  void clear(int itemId) {
	  super.clear(itemId);

	  for (int i=0; i < keys; i++) {
		  visualItems[i].pong();
	  }
  }
}

class VZVideo extends VisualItem {
  float boxWidth = screenWidth / 11;
  float boxHeight = screenHeight / 8;
  int keyId;
  Movie video;
  boolean active = false;
  boolean displayed = false;

  VZVideo(int keyNumber, color myColor, String movieFilePath, PApplet parent) {
    itemColor = myColor;
    keyId = keyNumber;
    video = new Movie(parent, movieFilePath);

    setPositionForIndex(keyId);
  }

  void update() {
    if (displayed && !active) {
      tint(170);
      image(video, x, y, boxWidth, boxHeight);
    } else if (!displayed && !active) {
    } else if (active) {
      if (video.available()) {
        video.read();
      }

      noTint();
      image(video, x, y, boxWidth, boxHeight);
      displayed = true;
    }
  }

  void ping() {
    //println("Key: " + keyId + " is down");
    active = true;
    video.loop();
    video.volume(0);
  }

  void pong() {
    //println("Key: " + keyId + " is up");
    active = false;
    video.pause();
  }

  void setPositionForIndex(int index) {
    int yLine = 0;
    float xPosition = 0;

    for (int i=0; i < index; i++) {
      xPosition += boxWidth;

      if ((xPosition + boxWidth) >= width) {
        xPosition = 0;
        yLine++;
      }
    }

	x = xPosition;
	y = yLine * boxHeight;
  }
}
