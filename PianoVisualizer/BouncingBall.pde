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

    if (y >= screenHeight) {
      y = screenHeight;
    } else {
      y = y + (screenHeight * intensity);
    }
  }

  void ping(int velocity) {
    if (y >= screenHeight) {
      y = 0;
    } else {
      y = y - (screenHeight * (intensity * 10));
    }
  }
}
