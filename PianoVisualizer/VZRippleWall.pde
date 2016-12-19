class VZRippleWall extends Visualizer {

  VZRippleWall(int[] colorSet) {
    float increment = screenWidth / keys;
    color startColor = colorSet[0];
    color endColor = colorSet[1];

    for (int i = 0; i < keys; i++) {
      addItemWithId(new VIRippleDots(i, lerpColor(startColor, endColor, 0.01 * i)), i);
    }
    noStroke();
  }

  void clear(int someId) {
    background(0);
  }
}


class WallDot {
  PVector pos;
  color dotColor;

  WallDot(int keyId, int myColor) {
    pos = new PVector(random(width / keys) + (keyId * (width / keys)), 
      random(height/2));
    //colorMode(RGB,255);

    dotColor = color(hue(myColor), saturation(myColor), brightness(myColor), 60 + random(40));
  }

  void update(float intensity) {
    if (intensity > 0) {
      fill(dotColor);
      ellipse(pos.x, pos.y, 1+intensity, 1+intensity);
    }
  }
}

class VIRippleDots extends VisualItem {
  ArrayList<WallDot> dots;
  final int dotCount = 20;
  float decayRate = 0.1;
  float intensity = 0;

  VIRippleDots(int keyId, int dotColor) {

    dots = new ArrayList<WallDot>();

    for (int i=0; i < dotCount; i++) {
      dots.add(new WallDot(keyId, dotColor));
    }
  }

  void update() {
    for (int i = 0; i < dotCount; i++) {
      if (intensity > 0) {
        WallDot d = dots.get(i);
        d.update(intensity);
      }

      if (intensity <= 0) {
        intensity = 0;
      } else {
        if (!active) {
          intensity -= decayRate;
        }
      }
    }
  }

  void ping() {
    intensity = 30;
  }
}