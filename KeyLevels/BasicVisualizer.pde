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
      }
    }
  }
}

