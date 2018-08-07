class ColoredSlash extends VisualItem {
  int intensity = 0;
  float decayRate = 5;
  color slashColor;
  Slash slashObject;

  ColoredSlash(color myColor) {
    slashColor = myColor;
    slashObject = new Slash(myColor);
  }

  void update() {

    if (intensity > 0) {
      slashObject.draw();
    }

    //slashObject.setColor(color(slashColor, intensity));

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

class Slash {
    float x1, x2, y1, y2, tarX1, tarX2, tarY1, tarY2, easing = random(0.01,0.1);
    int timer, tMax, taille=35, delta=240;
    boolean vertical;
    color c;

    Slash(color _c) {
        c=_c;
        initSlash();
    }

    void setColor(color myColor) {
       c = myColor;
    }

    void initSlash() {
        timer=0;
        tMax= (int) random(60, 150);
        vertical=random(1)>.5;

        x1=x2=(int)random(1, int(width/40)-1)*40;
        y1=y2=(int)random(1, int(screenHeight/40)-1)*40;

        if(x1<width/2) tarX2=x1+delta;
        else tarX2=x1-delta;

        if(y1<screenHeight/2) tarY2=y1+delta;
        else tarY2=y1-delta;
    }

    void draw() {
        x2=ease(x2, tarX2, easing);
        y2=ease(y2, tarY2, easing);
        if (abs(x2-tarX2)<=1) {
            timer++;

            if (timer>tMax) {
                tarX1=tarX2;
                tarY1=tarY2;
                x1=ease(x1, tarX1, easing);//
                y1=ease(y1, tarY1, easing);

                if (abs(x1-tarX1)<=1) {
                    initSlash();
                }
            }
        }

        noStroke();
        fill(c,200);
        if (vertical) quad(x1, y1-taille, x1, y1+taille, x2, y2+taille, x2, y2-taille);
        else quad(x1-taille, y1, x1+taille, y1, x2+taille, y2, x2-taille, y2);
    }

    // a snippet function i often use for animation easing
    float ease(float value, float target, float easingVal) {
        float d = target - value;
        if (abs(d)>1) value+= d*easingVal;
        return value;
    }
}
