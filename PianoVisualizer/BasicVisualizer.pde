class BasicVisualizer extends Visualizer {

  // This is the controller class for all the version 1 visualziers that were created
  // for Amelia. This shell class is just a convenience to reduce code elsewhere.
  BasicVisualizer(int visualizerId, int[] colorSet) {
    float increment = width / keys;
    color startColor = colorSet[0];
    color endColor = colorSet[1];

    for (int i=0; i < keys; i++) {
      float lerpAmount = (1/keys) * i;

      switch(visualizerId) {
      case 0:
        addItemWithId(new Bar(increment, increment*i, lerpColor(startColor, endColor, lerpAmount)), i);
        break;
      case 1:
        addItemWithId(new BouncingBall(increment*i + (width / keys)/2, screenHeight, lerpColor(startColor, endColor, 0.01 * i), screenWidth / keys), i);
        break;
      case 2:
        addItemWithId(new ColorCube(i, lerpColor(startColor, endColor, lerpAmount)), i);
        break;
      case 3:
        addItemWithId(new LineTree(i, lerpColor(startColor, endColor, 0.01 * i)), i);
        break;
      case 4:
        addItemWithId(new Ring(i, keys, lerpColor(startColor, endColor, lerpAmount)), int(keys - 1 - i));
        break;
      case 5:
        addItemWithId(new RippleTriangle(i, lerpColor(startColor, endColor, 0.01 * i)), i);
        break;
      case 6:
        addItemWithId(new TriangleNoise(lerpColor(startColor, endColor, 0.01 * i)), i);
        break;
      case 7:
        addItemWithId(new RoamingLine(lerpColor(startColor, endColor, 0.01 * i)), i);
        break;
      case 8:
        addItemWithId(new ColoredSlash(lerpColor(startColor, endColor, 0.01 * i)), i);
        break;
      }
    }
  }

  void clear(int visualizerId) {
    colorMode(RGB, 255);
    noStroke();

    switch(currentVisualization) {
    case 3:
      fill(0);
      break;
    case 7:
      fill(0, 0, 0, 10);
      break;
    case 8:
      fill(0, 0, 0, 20);
      break;
    case 9:
      fill(0, 0, 0, 70);
      break;
    default:
      fill(0, 0, 0, 40);
      break;
    }

    rect(0, 0, width, height);
  }
}