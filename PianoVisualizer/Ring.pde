class Ring extends VisualItem {
  color ringColor;
  int intensity = 0;
  int decayRate = 20;
  float spacing;
  float innerRing, outerRing;

  Ring(int index, float totalKeys, color myColor) {
    ringColor = myColor;
    keyId = index;
    spacing = (width / totalKeys);
    outerRing = (spacing * keyId) + (spacing * .9);
  }

  void update() {
	  if (intensity > 0) {
		noFill();
	    stroke(ringColor, intensity);
	    strokeWeight(11);
	    ellipse(width/2, screenHeight/2, outerRing, outerRing);
	}
	
    if (intensity <= 0) {
      intensity = 0;
    } else {
      if (!active) {
        intensity -= decayRate;
      }
    }
  }

  void ping() {
    intensity = 255;
  }
}
