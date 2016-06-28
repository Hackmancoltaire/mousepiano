class VZWisp extends Visualizer {
  int elapsedFrames = 0;
  ArrayList points = new ArrayList();
  boolean drawing = false;

  VZWisp(int[] colorSet) {
    float increment = screenWidth / keys;
    color startColor = colorSet[0];
    color endColor = colorSet[1];

    background(0);

    for (int i=0; i < keys; i++) {
      visualItems[i] = new VZWispParticle(i, ((increment/2) + increment*i), lerpColor(startColor, endColor, 0.01 * i));
    }

    setup = true;
  }

  void update(int itemId) {
    visualItems[itemId].update();
  }

  void ping(int itemId) {
    visualItems[itemId].ping();
  }

  void pong(int itemId) {
    visualItems[itemId].pong();
  }

  void clear(int someId) {
    if (currentOverlay.textDelay > 0) {
      background(0);
      currentOverlay.textDelay -= 1;
    } else {
      colorMode(RGB, 255);
      noStroke();
      fill(0, 0, 0, 8);
      rect(0, 0, width, screenHeight);
    }
  }
}

int[] VZWispElapsedFrames = new int[88];

class VZWispParticle extends VisualItem {
  ArrayList points = new ArrayList();
  boolean drawing = false;
  int index;

  VZWispParticle(int keyIndex, float startX, color myColor) {
    x = startX;
    y = screenHeight/2;
    index = keyIndex;
    itemColor = myColor;
  }

  void ping() {
    drawing = true;
  }

  void pong() {
    drawing = false;
  }

  void update() {
    if (drawing == true) {
      PVector pos = new PVector();
      pos.x = x;
      pos.y = y;

      PVector vel = new PVector();
      vel.x = (0);
      vel.y = (0);

      VZWispPoint punt = new VZWispPoint(index, pos, vel, 250, itemColor);
      points.add(punt);
    }


    for (int i = 0; i < points.size(); i++) {
      VZWispPoint localPoint = (VZWispPoint) points.get(i);
      if (localPoint.isDead == true) {
        points.remove(i);
      }
      localPoint.update();
      localPoint.draw();
    }

    VZWispElapsedFrames[index]++;
  }
}

class VZWispPoint {
  PVector pos, vel, noiseVec;
  float noiseFloat, lifeTime, age;
  boolean isDead;
  color itemColor;
  int index;

  public VZWispPoint(int keyIndex, PVector _pos, PVector _vel, float _lifeTime, color myColor) {
    index = keyIndex;
    pos = _pos;
    vel = _vel;
    lifeTime = _lifeTime;
    age = 0;
    isDead = false;
    noiseVec = new PVector();
    itemColor = myColor;
  }

  void update() {
    noiseFloat = noise(pos.x * 0.0025, pos.y * 0.0025, VZWispElapsedFrames[index] * 0.001);
    noiseVec.x = cos(((noiseFloat -0.3) * TWO_PI) * 10);
    noiseVec.y = sin(((noiseFloat - 0.3) * TWO_PI) * 10);

    vel.add(noiseVec);
    vel.div(1.5);
    pos.add(vel);

    if (1.0-(age/lifeTime) == 0) {
      isDead = true;
    }

    if (pos.x < 0 || pos.x > screenWidth || pos.y < 0 || pos.y > screenHeight) {
      isDead = true;
    }

    age++;
  }

  void draw() {
    fill(itemColor, 40);
    noStroke();
    ellipse(pos.x, pos.y, 4-(age/lifeTime), 4-(age/lifeTime));
  }
};