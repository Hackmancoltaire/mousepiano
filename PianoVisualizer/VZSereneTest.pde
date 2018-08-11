import java.util.ListIterator;

class VZSereneTest extends Visualizer {
	PFont wakandaFont;

	VZSereneTest(int[] colorSet) {
		float increment = screenWidth / keys;
	    color startColor = colorSet[0];
	    color endColor = colorSet[1];
		wakandaFont = createFont("WakandaForever-Regular", 128, true);

	    for (int i = 0; i < keys; i++) {
	      addItemWithId(new VISereneTestLayer(i, lerpColor(startColor, endColor, 0.01 * i), wakandaFont), i);
	    }
	}
}

class SereneTestCharacter extends VisualItem {
	String character;
	boolean isUp = false;
	PFont myFont;

	SereneTestCharacter(int id, String myCharacter, int myColor, PFont font) {
		myFont = font;
		character = myCharacter;
		keyId = id;
		// itemColor = myColor;
		itemColor = color(0,100,0);

		x = random(width);
		isUp = (random(1) > 0.5);
		y = (isUp) ? 0:screenHeight;
	}

	void update(float intensity) {
		int textSize = int(map(keyId, 88, 0, 16, 32));
		int textSpeed = int(map(keyId, 0, 88, 4, 16));
		int colorIntensity = int(map(keyId, 0, 88, 64, 255));

		y = (isUp) ? y+textSpeed:y-textSpeed;
		fill(itemColor, colorIntensity);
		textFont(myFont, textSize);
		text(character, x, y);
		int rfactor = 100;
		for (int i=0 ; i < 30 ; i++) {
			text(character, x + i*4*random(1) * rfactor, y + random(1) * rfactor);
		}
	}
}

class VISereneTestLayer extends VisualItem {
	ArrayList<SereneTestCharacter> wCharacters;
	ArrayList<SereneTestCharacter> tempAddCharacters;

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

	VISereneTestLayer(int id, color myColor, PFont font) {
		keyId = id;
		myFont = font;
		myCharacter = characters[int(map(keyId, 0, 88, 0, characters.length))];
		itemColor = myColor;
		wCharacters = new ArrayList<SereneTestCharacter>();
		tempAddCharacters = new ArrayList<SereneTestCharacter>();
	}

	void update() {
		print((Runtime.getRuntime().totalMemory()/1024/1024) + "/" + (Runtime.getRuntime().freeMemory()/1024/1024) + "\n");

		ListIterator<SereneTestCharacter> characterIterartor = wCharacters.listIterator();

		while(characterIterartor.hasNext()) {
			SereneTestCharacter character = characterIterartor.next();

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
		tempAddCharacters.add(new SereneTestCharacter(keyId, myCharacter, itemColor, myFont));
	}
}
