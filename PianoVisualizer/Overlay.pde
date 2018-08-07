// All the various informational overlays and attraction screens
// also any mouse animations for the future.

class Overlay {
	public int textDelay = 0;
	int textMaxShow = 5;
	String currentText = "";

	color defaultColor = color(255,255,255);
	int defaultTextSize = 128;

	color currentColor = defaultColor;
	int currentTextSize = defaultTextSize;

	PImage playMeImage;
	public boolean showPlayMe = false;

	boolean activePlay = false;
	int lastPlay = millis();

	Overlay() {
		playMeImage = loadImage(dataPath("images") + "/frame.png");
		lastPlay = millis() + 10000;
	}

	void displayPlayMe(boolean state) {
		showPlayMe = state;
	}

	void setTextColor(color newColor) {
		currentColor = newColor;
	}

	void setTextSize(int size) {
		currentTextSize = size;
	}

	void displayMessage(String message) {
		currentText = message;
		// Display message for n second
		textDelay = millis() + (textMaxShow * 1000);
	}

	void update() {
		if (textDelay > 1 && currentText != "" && millis() < textDelay) {
			colorMode(RGB, 255);
			fill(currentColor);
			textFont(standardFont);
			textSize(currentTextSize);
			textAlign(CENTER);
			text(currentText, screenWidth/2, screenHeight/2);
		}

		if (showPlayMe && millis() > lastPlay) {
			tint(255);
			image(playMeImage, 0, 0);
		}
 	}

	void ping(int velocity) {
		lastPlay = millis() + 10000;
	}
}
