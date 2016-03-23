class ColorCube extends VisualItem {
  color cubeColor;
  float boxWidth = screenWidth / 11;
  float boxHeight = screenHeight / 8;
  float z = 0.0;
  int keyId;
  int intensity = 30;

  ColorCube(int keyNumber, color myColor) {
    cubeColor = myColor;
    keyId = keyNumber;

    setPositionForIndex(keyId);
  }

  void update() {
    pushMatrix();
    translate(x + (boxWidth/2), y + (boxHeight/2), z);
    fill(cubeColor);
    strokeWeight(1);
    stroke(0);
    //rect(x,y, boxWidth, boxHeight);
    box(boxWidth, boxHeight, 10);
    popMatrix();

    if (z <= 0) {
      z = 0;
    } else {
      z -= 1;
    }
  }

  void ping() {
    z += intensity;
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
