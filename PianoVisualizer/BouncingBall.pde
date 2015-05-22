class BouncingBall extends VisualItem {
  float size = 20;
  float x, y;
  color ballColor;
  float intensity = 0.01;

  BouncingBall(float startX, float startY, color myColor, float mySize) {
    x = startX;
    y = startY;
    ballColor = myColor;
    size = mySize;
  }

  void update() {
    fill(ballColor);
    noStroke();
    ellipse(x, y, size, size);

    if (y >= height) {
      y = height;
    } else {
      y = y + (height * intensity);
    }
  }

  void ping() {
    if (y >= height) {
      y = 0;
    } else {
      y = y - (height * (intensity * 10));
    }
  }
}

