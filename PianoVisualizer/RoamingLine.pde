class RoamingLine extends VisualItem {
  float radius = 50;

  float x, y;
  float prevX, prevY;
  color lineColor;
  int intensity = 0;
  float decayRate = 20;

  RoamingLine(color myColor) {
    lineColor = myColor;

    x = width/2;
    y = screenHeight/2;

    prevX = x;
    prevY = y;
  }

  void update() {
    if (intensity > 0) {
      float angle = (TWO_PI / 6) * floor( random( 6 ));

      x += cos( angle ) * radius;
      y += sin( angle ) * radius;

      if ( x < 0 || x > width ) {
        x = prevX;
        y = prevY;
      }

      if ( y < 0 || y > screenHeight) {
        x = prevX;
        y = prevY;
      }

      stroke(lineColor, intensity);
      strokeWeight( 5 );
      line( x, y, prevX, prevY );

      strokeWeight( 8 );
      point( x, y );

      prevX = x;
      prevY = y;
    }

    if (intensity <= 0) {
      intensity = 0;
    } else {
      intensity -= decayRate;
    }
  }

  void ping(int velocity) {
    intensity = 255;
  }
}
