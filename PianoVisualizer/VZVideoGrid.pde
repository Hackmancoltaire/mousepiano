class VZVideoGrid extends Visualizer {
  Movie[] videos = new Movie[88];


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

    videos[0] = new Movie(parent, (dataPath("bowie/video") + "/blackstar.3gpp"));

    for (int i=0; i < keys; i++) {
      visualItems[i] = new VZVideo(i, lerpColor(startColor, endColor, 0.01 * i), videos[0], parent);
    }

    setup = true;
  }
}

class VZVideo extends VisualItem {
  float boxWidth = screenWidth / 11;
  float boxHeight = screenHeight / 8;
  int keyId;
  Movie video;
  boolean displayed = false;

  VZVideo(int keyNumber, color myColor, Movie myVideo, PApplet parent) {
    itemColor = myColor;
    keyId = keyNumber;
    video = myVideo;

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

  void ping(int velocity) {
    video.loop();
    video.volume(0);
  }

  void pong() {
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
