class Ring extends VisualItem {
  color ringColor;
  int intensity = 0;
  int decayRate = 20;
  float spacing;
  int keyIndex;
  float innerRing, outerRing;

  Ring(int index, float totalKeys, color myColor) {
    ringColor = myColor;
    keyIndex = index;
    spacing = (width / totalKeys);
    innerRing = (spacing * keyIndex);
    outerRing = innerRing + (spacing * .9);
  }

  void update() {
    //colorMode(RGB, 255);
    fill(ringColor, intensity);
    noStroke();
    ellipse(width/2, height/2, outerRing, outerRing);
    fill(0);
    ellipse(width/2, height/2, innerRing, innerRing);

    if (intensity <= 0) {
      intensity = 0;
    } else {
      intensity -= decayRate;
    }
  }

  void ping() {
    intensity = 255;
  }
}

