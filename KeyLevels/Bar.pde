class Bar extends VisualItem {
  float barWidth;
  float x = 0.0;
  color barColor;
  int intensity = 0;
  float decayRate = 50;

  Bar(float w, float xpos, color myColor) {
    barWidth = w;
    x = xpos;
    barColor = #00FF00;
  }

  void update() {
      float newHeight = map(intensity,0,255,0,height);
    
      colorMode(RGB, 255);
      textSize(10);
      fill(barColor, 255);
      rect(x, 0, barWidth, newHeight);
      fill(255);
      text(intensity, x, newHeight); 
  }

  void setValue(int value) {
    intensity = value;
  }

  void ping() {
    barColor = #FF0000;
  }
  
  void pong() {
     barColor = #00FF00; 
  }
}