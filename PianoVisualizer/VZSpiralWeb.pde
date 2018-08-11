class VZSpiralWeb extends Visualizer {

  VZSpiralWeb(int[] colorSet) {
    float increment = screenWidth / keys;
    color startColor = colorSet[0];
    color endColor = colorSet[1];

    for (int i = 0; i < keys; i++) {
      addItemWithId(new VISpiralVector(i, increment*i, lerpColor(startColor, endColor, 0.01 * i)), i);
    }
  }

  void clear(int someId) {
    background(0);
  }
}

class VISpiralVector extends VisualItem {
  float distance = 200;
  float decayRate = 1;
  float intensity = 0;
  color lineColor;
  float startLocation;
  float rotation = 0;

  VISpiralVector(int keyId, float xLocation, int myColor) {
	  lineColor = myColor;
	  startLocation = xLocation;
  }

  void update() {
	  translate(0,screenHeight/2);

	  float angX = (startLocation)*TWO_PI/screenHeight;
  	float angY = (screenHeight/2)*TWO_PI/rotation;

	if (rotation >= 360) {
		rotation=0;
		rotateX(radians(0));
	  } else {
		rotateX(radians(rotation));
		  rotation++;
	  }

	  if (intensity > 0) {
		  pushMatrix();
  rotateX(-angX);
  rotateY(angY);
		line(startLocation,screenHeight,0,startLocation,screenHeight,distance);
		strokeWeight(2);
		stroke(lineColor, intensity);
		popMatrix();
      }



      if (intensity <= 0) {
        intensity = 0;
      } else {
        if (!active) {
          intensity -= decayRate;
        }
      }

  }

  void ping(int velocity) {
    intensity = 255;
  }
}
