class Dictionary extends VisualItem {
  String[] words = {
    "adoration", 
    "affection", 
    "agreement", 
    "amour", 
    "attachment", 
    "attune", 
    "baby", 
    "belly", 
    "beloved", 
    "bird", 
    "blend", 
    "canorous", 
    "cherish", 
    "chime", 
    "chord", 
    "concent", 
    "conform", 
    "correspond", 
    "courtship", 
    "cupid", 
    "darling", 
    "delight", 
    "descant", 
    "eros", 
    "erudition", 
    "euphonious", 
    "feeling", 
    "felicity", 
    "fondness", 
    "friendship", 
    "fruition", 
    "gratification", 
    "gusto", 
    "happiness", 
    "harmonic", 
    "harmonious", 
    "harmonize", 
    "harmony", 
    "honey", 
    "humanity", 
    "idolism", 
    "inamorato", 
    "kindness", 
    "ladylove", 
    "learning", 
    "like", 
    "love", 
    "luxury", 
    "mate", 
    "mathematics", 
    "mellifluous", 
    "mellisonant", 
    "mellow", 
    "melodious", 
    "melodize", 
    "melody", 
    "music", 
    "musical", 
    "nothing", 
    "orphean", 
    "orphic", 
    "passion", 
    "pet", 
    "philharmonic", 
    "play", 
    "pleasure", 
    "reconcile", 
    "relish", 
    "rhythm", 
    "rich", 
    "ring", 
    "rondo", 
    "satisfaction", 
    "silvery", 
    "singing", 
    "sirenic", 
    "songful", 
    "suit", 
    "sweet", 
    "sweetheart", 
    "sweety", 
    "tenderness", 
    "tunable", 
    "tune", 
    "united", 
    "venus", 
    "vibe", 
    "zest"
  };

  int keyIndex;
  boolean[] activeKeys;
  color textColor;
  int circleSize = 30;

  Dictionary(int index, boolean keys[], color myColor) {
    keyIndex = index;
    activeKeys = keys;
    textColor = myColor;
  }

  void update() {
    if (activeKeys[keyIndex]) {
      fill(textColor);
      textSize(64);
      int evenWords = 0;
      int oddWords = 0;
      int position = 0;
      float yPos = 0.0;

      for (int i=0; i < activeKeys.length; i++) {
        if (activeKeys[i] == true) {
          if (i % 2 == 0) {
            evenWords++;

            if (i == keyIndex) {
              position = evenWords;
            }
          } else {
            oddWords++;

            if (i == keyIndex) {
              position = oddWords;
            }
          }
        }
      }

      if (keyIndex % 2 == 0) {
        textAlign(LEFT);
        yPos = (65 * position);
        text(words[keyIndex], 20, yPos);
      } else {
        textAlign(RIGHT);
        yPos = (65 * position);
        text(words[keyIndex], width-20, yPos);
      }
      
      pushMatrix();
      translate(width/2, height/2);
      rotate(radians((360.0/88.0) * keyIndex));
      fill(textColor);
      triangle(0,0, 500, 20, 500, -20);
      //ellipse(height/2 - circleSize/2, 0, circleSize, circleSize);
      popMatrix();
      //println(keyIndex+": "+position+", "+yPos);
    }
  }
}
