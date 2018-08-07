class Bar extends VisualItem {
  float barWidth;
  float x = 0.0;
  color barColor;
  int intensity = 0;
  float decayRate = 50;

  Bar(float w, float xpos, color myColor) {
    barWidth = w;
    x = xpos;
    barColor = myColor;
  }

  void update() {
    if (intensity <=0) {
      return;
    } else {
      colorMode(RGB, 255);
      fill(barColor, intensity);
      stroke(0);
    }

    strokeWeight(3);
    rect(x, 0, barWidth, screenHeight);

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
