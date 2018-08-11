class VZMatrix extends Visualizer {
	float gridsize = 21.81;
	int cont = 30;
	ArrayList<SymbolHead> symbolhead;
	PFont matrixFont;
	color startColor;
	color endColor;
	boolean[] itemOn = new boolean[88];

	VZMatrix(int[] colorSet) {
		symbolhead = new ArrayList<SymbolHead>();
		startColor = colorSet[0];
		endColor = colorSet[1];
		noStroke();
		matrixFont = loadFont(dataPath("VZMatrix") + "/MatrixCodeNFI-16.vlw");
	}

	void update() {
		for (int i = 0; i < symbolhead.size(); i++) {
			SymbolHead letra = (SymbolHead) symbolhead.get(i);
			letra.update();
			if (!letra.alive) { symbolhead.remove(i); }
		}
	}

	void ping(int itemId, int velocity) {
		if (!itemOn[itemId]) {
			colorMode(HSB, 100);
			symbolhead.add(new SymbolHead(itemId, -1, matrixFont,
				lerpColor(startColor, endColor, 0.01 * itemId)));
			itemOn[itemId] = true;
		}
	}

	void pong(int itemId) {
		itemOn[itemId] = false;
	}

	//void clear(int someId) { }
}

char getRandomChar() {
	String chrlist = "abcdefghijklmnopqrstuvwxyz0123456789";

	return chrlist.charAt((int) random(chrlist.length()));
}

class SymbolHead extends VisualItem {
	int cont;
	int speed = (int) random(3, 6);
	char chr;
	boolean alive;
	ArrayList<SymbolTail> tail;
	float gridsize = 21.81;
	PFont matrixFont;

	SymbolHead(float xini, float yini, PFont myFont, color myColor) {
		tail = new ArrayList<SymbolTail>();
		x = xini;
		y = yini;
		chr = getRandomChar();
		cont = 0;
		alive = true;
		matrixFont = myFont;
		itemColor = myColor;
	}

	void update() {
		if ((y * gridsize) < screenHeight) {
			fill(0);
			rect((x * gridsize)-(gridsize/2), (y * gridsize)-18, gridsize, gridsize);
			fill(255);
			textFont(matrixFont, gridsize);
			text(chr, x * gridsize, y * gridsize);
			cont++;

			if (cont%speed == 0) {
				if ((int) random(5) != 0) {
					tail.add(new SymbolTail(x, y, (int) random(10, 20), chr, matrixFont, itemColor));
					chr = getRandomChar();
					y++;
				}
			}
		}

		for (int i = 0; i < tail.size(); i++) {
			SymbolTail cauda = (SymbolTail) tail.get(i);
			cauda.update();

			if (cauda.alive == false) {
				tail.remove(i);
			}
		}
	}
}

class SymbolTail extends VisualItem {
	int cont;
	int speed = (int) random(3, 6);
	int life;
	char chr;
	boolean alive;
	float gridsize = 21.81;
	PFont matrixFont;

	SymbolTail(float xini, float yini, int lifeini, char chrini, PFont myFont, color myColor) {
		x = xini;
		y = yini;
		life = lifeini;
		cont = 0;
		chr  = chrini;
		alive = true;
		matrixFont = myFont;
		itemColor = myColor;
	}

	void update() {
		if ((y * gridsize) < screenHeight) {
			if ((int) random(0, 50) == 0 && cont > 10) {
				chr = getRandomChar();
			}

			textFont(matrixFont, gridsize);
			fill(0);
			rect((x * gridsize)-(gridsize/2), (y * gridsize)-18, gridsize, gridsize);
			fill(itemColor);
			text(chr, x * gridsize, y * gridsize);
			cont++;
		}

		if (cont%speed == 0) {
			life--;
			if (life <= 0) { alive = false; }
		}
	}
}
