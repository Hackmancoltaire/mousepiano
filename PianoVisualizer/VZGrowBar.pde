class VZGrowBar extends Visualizer {
  VZGrowBar(int[] colorSet) {
    float increment = screenWidth / keys;
    color startColor = colorSet[0];
    color endColor = colorSet[1];

    for (int i = 0; i < keys; i++) {
      addItemWithId(new VIGrowBar(increment, increment * i, lerpColor(startColor, endColor, 0.01 * i)), i);
    }
  }

  void clear(int someId) {
    background(0);
  }
}

class VIGrowBar extends VisualItem {
	float barWidth;
	float x = 0.0;
	color barColor;
	int intensity = 0;
	float decayRate = 50;
	boolean grow = false;
	float barHeight = 0;

	VIGrowBar(float w, float xpos, color myColor) {
	  barWidth = w;
	  x = xpos;
	  barColor = myColor;
	}

	void update() {
		if (grow && barHeight < (screenHeight/2)) {
			barHeight = barHeight + 2.5;
		} else {
			if (barHeight > 0) {
				barHeight = barHeight - 1;
			}
		}

	  if (intensity <=0) {
		 return;
	  } else {
		 colorMode(RGB, 255);
		 fill(barColor, intensity);
		 stroke(0);
	  }

	  strokeWeight(3);

	  rect(x, 0, barWidth, barHeight);
	  rect(x, screenHeight, barWidth, -barHeight);

	  if (intensity <= 0) {
		 intensity = 0;
	  } else {
		 if (!active) {
		   intensity -= decayRate;
		 }
	  }
	}

	void ping(int velocity) {
	  intensity = 255;
	  grow = true;
	}

	void pong() {
		grow = false;
	}
}
