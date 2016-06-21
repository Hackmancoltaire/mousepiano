class DottedLineVisualizer extends Visualizer {
  DottedLineVisualizer(int[] colorSet) {
    float increment = width / keys;
    color startColor = colorSet[0];
    color endColor = colorSet[1];

    for (int i=0; i < keys; i++) {
      addItemWithId(new Dot(increment*i + (width / keys)/2, screenHeight/2, lerpColor(startColor, endColor, 0.01 * i), screenWidth / keys, boolean(i%2)), i);
    }
    setup = true;
  }

  void update(int itemId) {
    for (int i=0; i < keys - 1; i++) {
      strokeWeight(3);
      stroke(lerpColor(visualItems[i].itemColor, visualItems[i+1].itemColor, 0.5));
      line(visualItems[i].x, visualItems[i].y, visualItems[i+1].x, visualItems[i+1].y);
    }

    super.update(itemId);
  }
}

class Dot extends VisualItem {
  float size = 20;
  float intensity = 0.01;
  boolean isEven = false;

  Dot(float startX, float startY, color newColor, float mySize, boolean even) {
    x = startX;
    y = startY;
    itemColor = newColor;
    size = mySize;
    isEven = even;
  }

  void update() {
    fill(itemColor);
    noStroke();

    if (isEven && (y < screenHeight / 2)) {
      y = y + (screenHeight * intensity);
    } else if (!isEven && (y > screenHeight /2)) {
      y = y - (screenHeight * intensity);
    } else {
      y = screenHeight/2;
    }

    if (y >= screenHeight) {
      y = screenHeight;
    } else if (y <= 0) {
      y = 0;
    }

    ellipse(x, y, size, size);
  }

  void ping() {
    if (isEven) {
      y = y - (screenHeight * (intensity * 10));
    } else {
      y = y + (screenHeight * (intensity * 10));
    }
  }
}