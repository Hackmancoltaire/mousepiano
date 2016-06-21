class LineTree extends VisualItem {
  float intensity = 0;
  float increase= 0;
  color lineColor;
  float x;
  int keyIndex;
  int w;              // Width of entire wave

  float decay = 0.975;
  float[] yvalues;  // Using an array to store height values for the wave
  float spacing;

  LineTree(int keyID, color myColor) {
    intensity = (screenHeight/2) / 3;
    keyIndex = keyID;
    lineColor = myColor;
    yvalues = new float[15];
    spacing = width/yvalues.length;
  }

  void update() {
    colorMode(RGB, 255);
    stroke(lineColor);
    strokeWeight(3);
    float x1, x2, y1, y2;

    for (int x = 0; x < yvalues.length; x++) {
      x1 = spacing * x;

      if (x+1 != yvalues.length) {
        x2 = spacing * (x+1);

        if (keyIndex % 2 == 0) { 
          y1 = screenHeight/2-yvalues[x];
          y2 = screenHeight/2-yvalues[x+1];
        } else {
          y1 = screenHeight/2+yvalues[x];
          y2 = screenHeight/2+yvalues[x+1];
        }

        float c1x = x2;
        float c1y = y1;

        float c2x = x1;
        float c2y = y2; 

        bezier(x1, y1, c1x, c1y, c2x, c2y, x2, y2);
      }
      else {
        if (keyIndex % 2 == 0) { 
          y1 = screenHeight/2-yvalues[x];
        } else {
          y1 = screenHeight/2+yvalues[x];
        }
        
        line(x1, y1, width, y1);
      }
    }

    if (increase >= screenHeight/2) {
      increase = (screenHeight/2)-1;
    } else {
      increase -= 8;
      
      if (increase < 0) {
         increase = 0;
      } 
    }
    
    shiftWave(increase);
  }

  void ping() {
    increase += intensity;
  }

  void shiftWave(float newValue) {
    if (newValue > screenHeight/2) {
      newValue = screenHeight/2;
    }  

    for (int i = 0; i < yvalues.length; i++) {
      if (i+1 < yvalues.length) {
        yvalues[i] = yvalues[i+1];
      } else {
        yvalues[i] = newValue;
      }
    }
  }
}