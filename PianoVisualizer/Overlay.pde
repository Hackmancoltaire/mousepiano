// All the various informational overlays and attraction screens
// also any mouse animations for the future.

class Overlay {
	public int textDelay = 0;
	int textMaxShow = 100;
	String currentText = "";

	PImage playMeImage;
	public boolean showPlayMe = false;

	boolean activePlay = false;
	int lastPlay = millis();

	Overlay() {
  }

	void displayPlayMe(boolean state) {
		showPlayMe = state;
	
    if (playMeImage == null) {
      println(dataPath("images"));
      playMeImage = loadImage(dataPath("images") + "/decoFrame.png");
    }
}

	void displayMessage(String message) {
  		currentText = message;
		  textDelay = textMaxShow;
	}

	void update() {
		if (textDelay > 1 && currentText != "") {
	      colorMode(RGB, 255);
	      fill(255);
	      textFont(standardFont);
	      textSize(128);
	      textAlign(CENTER);
        text(currentText, screenWidth/2, screenHeight/2);
	      textDelay -= 1;
	    }

		if (showPlayMe && millis() > (lastPlay + 20000)) {
      tint(255);
			image(playMeImage, 0, 0);
		}
 	}

	void ping() {
    lastPlay = millis();
	}
}