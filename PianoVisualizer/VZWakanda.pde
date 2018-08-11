import java.util.ListIterator;

class VZWakanda extends Visualizer {
	PFont wakandaFont;

	VZWakanda(int[] colorSet) {
	    color startColor = colorSet[0];
	    color endColor = colorSet[1];
		wakandaFont = createFont("WakandaForever-Regular", 128, true);

	    for (int i = 0; i < keys; i++) {
	      addItemWithId(new VIWakandaLayer(i, lerpColor(startColor, endColor, 0.01 * i), wakandaFont), i);
	    }
	}
}

class WakandaCharacter extends VisualItem {
	String character;
	boolean isUp = false;
	PFont myFont;
	int textSize;
	float textSpeed;
	int colorIntensity;

	WakandaCharacter(int id, String myCharacter, int myColor, PFont font) {
		myFont = font;
		character = myCharacter;
		keyId = id;
		itemColor = myColor;
		textSize = int(map(keyId, 0, 88, 240, 24));
		textSpeed = map(keyId, 0, 88, 1, 3) + random(1);
		colorIntensity = int(map(keyId, 0, 88, 64, 255));

		x = random(width);
		isUp = (random(1) > 0.5);
		y = (isUp) ? 0:screenHeight;
	}

	void update(float intensity) {
		y = (isUp) ? y+textSpeed:y-textSpeed;
		fill(itemColor, colorIntensity);
		textFont(myFont, textSize);
		text(character, x, y);
	}
}

long map(long x, long in_min, long in_max, long out_min, long out_max) {
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

class VIWakandaLayer extends VisualItem {
	ArrayList<WakandaCharacter> wCharacters;
	ArrayList<WakandaCharacter> tempAddCharacters;

	String[] characters = {
		"a","A",
		"b","B",
		"c","C",
		"d","D",
		"e","E",
		"f","F",
		"g","G",
		"h","H",
		"i","I",
		"j","J",
		"k","K",
		"l","L",
		"m","M",
		"n","N",
		"o","O",
		"p","P",
		"q","Q",
		"r","R",
		"s","S",
		"t","T",
		"u","U",
		"v","V",
		"w","W",
		"x","X",
		"y","Y",
		"z","Z",
		"1",
		"2",
		"3",
		"4",
		"5",
		"6",
		"7",
		"8",
		"9",
		"0"
	};

	String myCharacter;
	PFont myFont;

	VIWakandaLayer(int id, color myColor, PFont font) {
		keyId = id;
		myFont = font;
		myCharacter = characters[int(map(keyId, 0, 88, 0, characters.length))];
		itemColor = myColor;
		wCharacters = new ArrayList<WakandaCharacter>();
		tempAddCharacters = new ArrayList<WakandaCharacter>();
	}

	void update() {
		ListIterator<WakandaCharacter> characterIterartor = wCharacters.listIterator();

		while(characterIterartor.hasNext()) {
			WakandaCharacter character = characterIterartor.next();

			if (character.isUp && character.y == screenHeight ||
				!character.isUp && character.y == 0) {
				characterIterartor.remove();
			} else {
				character.update(0);
			}
		}

		if (tempAddCharacters.size() > 0) {
			wCharacters.addAll(tempAddCharacters);
			tempAddCharacters.clear();
		}
	}

	void ping(int velocity) {
		tempAddCharacters.add(new WakandaCharacter(keyId, myCharacter, itemColor, myFont));
	}
}
