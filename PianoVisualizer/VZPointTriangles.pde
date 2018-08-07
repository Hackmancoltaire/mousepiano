class VZPointTriangle extends Visualizer {
  ArrayList<VIParticle> particles;
  float distance = 90.0;

  VZPointTriangle(int[] colorSet) {
    float increment = screenWidth / keys;
    color startColor = colorSet[0];
    color endColor = colorSet[1];

    particles = new ArrayList<VIParticle>();

	  noStroke();

    for (int i = 0; i < keys; i++) {
      particles.add(new VIParticle(i, lerpColor(startColor, endColor, 0.01 * i)));
      particles.add(new VIParticle(i, lerpColor(startColor, endColor, 0.01 * i)));
      particles.add(new VIParticle(i, lerpColor(startColor, endColor, 0.01 * i)));
      particles.add(new VIParticle(i, lerpColor(startColor, endColor, 0.01 * i)));
    }
  }

  void update() {
    colorMode(RGB, 255);

    for (VIParticle p : particles) {
      fill(p.col);
      ellipse(p.pos.x, p.pos.y, 5, 5);
      p.update();
    }

    for (int i = 0; i < particles.size() - 2; i++) {
      VIParticle p1 = particles.get(i);
      for (int j = i + 1; j < particles.size() - 1; j++) {
        VIParticle p2 = particles.get(j);
        for (int k = j + 1; k < particles.size(); k++) {
          VIParticle p3 = particles.get(k);
          if ((p1.active || p2.active || p3.active) && PVector.dist(p1.pos, p2.pos) <= distance && PVector.dist(p2.pos, p3.pos) <= distance && PVector.dist(p3.pos, p1.pos) <= distance) {
            float r = (red(p1.col) + red(p2.col) + red(p3.col)) / 3;
            float g = (green(p1.col) + green(p2.col) + green(p3.col)) / 3;
            float b = (blue(p1.col) + blue(p2.col) + blue(p3.col)) / 3;
            fill(r, g, b, 100);
            triangle(p1.pos.x, p1.pos.y, p2.pos.x, p2.pos.y, p3.pos.x, p3.pos.y);
          }
        }
      }
    }
  }

  void clear(int someId) {
    colorMode(RGB, 255);
    noStroke();
    fill(0, 0, 0, 100);
    rect(0, 0, width, height);
  }

  void ping(int itemId, int velocity) {
  }

  void pong(int itemId) {
  }

  void setItemIdActive(int itemId, boolean activeState) {
	  VIParticle p = particles.get(itemId); p.active = activeState;
	  p = particles.get(itemId+1); p.active = activeState;
	  p = particles.get(itemId+2); p.active = activeState;
	  p = particles.get(itemId+3); p.active = activeState;
  }
}

class VIParticle extends VisualItem {
  PVector pos;
  PVector vel;
  color col;

  VIParticle(int id, color myColor) {
    keyId = id;
    pos = new PVector(random(width), random(height/2));
    float velAng = random(TWO_PI);
    vel = new PVector(3 * cos(velAng), 3 * sin(velAng));
    col = myColor;
  }

  void update() {
    pos.add(vel);
    if (pos.x < 0 || pos.x >= width) {
      vel.x *= -1;
    }
    if (pos.y < 0 || pos.y >= height/2) {
      vel.y *= -1;
    }
  }
}
