class ColorCube extends VisualItem {
  color cubeColor;
  float x, y, boxWidth;
  float z = 0.0;
  int keyId;
  int intensity = 30;
  
  ColorCube(int keyNumber, color myColor) {
    cubeColor = myColor;
    keyId = keyNumber;
    
    boxWidth = sqrt((width * height) / 88);
  }

  void update() {
    setPositionForIndex(keyId);
    pushMatrix();
    translate(x, y, z);
    fill(cubeColor);
    strokeWeight(1);
    stroke(0);
    box(boxWidth);
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
    float xPosition = index * boxWidth;
    boolean setupPosition = false;
    
    while (!setupPosition) {
      if (xPosition <= width) {
        x = xPosition + (boxWidth/2);
        y = (yLine * boxWidth) + (boxWidth/2);
        setupPosition = true;
      } else {
        xPosition -= width;
        yLine++; 
      }
    }
    
    //println(index+": "+x+", "+y);
  }
}
