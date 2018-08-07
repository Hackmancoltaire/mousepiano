class Dictionary extends Visualizer {
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

  //i, lerpColor(startColor, endColor, 0.01 * i)), i);

  Dictionary(int[] colorSet) {
    color startColor = colorSet[0];
    color endColor = colorSet[1];

    background(0);

    for (int i=0; i < keys; i++) {
      visualItems[i] = new VZWord(i, lerpColor(startColor, endColor, 0.01 * i), words[i]);
    }

    setup = true;
  }
}

class VZWord extends VisualItem {
  int keyIndex;
  int circleSize = 30;
  String word;

  VZWord (int index, color myColor, String myWord) {
    keyIndex = index;
    itemColor = myColor;
    word = myWord;
  }

  void ping(int velocity) {
    active = true;
  }

  void pong() {
    active = false;
  }

  void update() {
    if (active) {
      fill(itemColor);
      textSize(64);
      int evenWords = 0;
      int oddWords = 0;
      int position = 0;
      float yPos = 0.0;

	  int itemCount = currentVisualizer.visualItems.length;

      for (int i=0; i < itemCount; i++) {
        if (currentVisualizer.itemIsActive(i)) {
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
        text(word, 20, yPos);
      } else {
        textAlign(RIGHT);
        yPos = (65 * position);
        text(word, width-20, yPos);
      }

      pushMatrix();
      translate(width/2, screenHeight/2);
      rotate(radians((360.0/88.0) * keyIndex));
      fill(itemColor);
      triangle(0, 0, 500, 20, 500, -20);
      //ellipse(height/2 - circleSize/2, 0, circleSize, circleSize);
      popMatrix();
    }
  }
}
