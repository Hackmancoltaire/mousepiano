final float keys = 88.0;

import themidibus.*;
import java.util.HashMap;

import java.io.IOException;
import java.awt.image.BufferedImage;
import java.io.InputStream;
import java.io.ByteArrayInputStream;
import javax.imageio.ImageIO;
import javax.jmdns.JmDNS;
import javax.jmdns.ServiceInfo;
import processing.net.*;
import org.apache.commons.codec.binary.Base64;
import processing.video.*;

boolean tweet = false;

MidiBus myBus; // The MidiBus
boolean showMessages = false;

// How many seconds before cycling visualizer?
int cycleTime = 60;
int lastCycle = millis();
boolean cycleVisualizers = true;

int currentVisualization = 17;
int totalVisualizers = 17;
Visualizer currentVisualizer;

boolean sustain = false;
boolean setup = false;
int screenWidth = 1920;
int screenHeight = 540;

boolean[] activeKeys = new boolean[int(keys)];

int currentColorSet = 0;
int colorSetCount = 0;

String REMOTE_TYPE = "_processing._tcp.local.";
String name = "Amelia Visualizer";

JmDNS jmdns;
ServiceInfo pairservice;

Server myServer;
int port = 1024;
String finalString;

PFont standardFont;

Tweet currentTweet;

Overlay currentOverlay;

int gHue = 0;

void setup() {
  //fullScreen(P3D);
  size(1920, 1080, P3D);
  frameRate(60);

  standardFont = createFont("Desdemona", 128, true);
	currentOverlay = new Overlay();
  noCursor();
  background(0);

	setupBusConnection(-1);

  if (tweet) {
    try {
      jmdns = JmDNS.create();

      final HashMap<String, String> values = new HashMap<String, String>();
      values.put("DvNm", "Android-");
      values.put("RemV", "10000");
      values.put("DvTy", "iPod");
      values.put("RemN", "Remote");
      values.put("txtvers", "1");

      pairservice = ServiceInfo.create(REMOTE_TYPE, name, port, 0, 0, values);
      jmdns.registerService(pairservice);
    }
    catch (IOException e) {
      e.printStackTrace();
    }

    myServer = new Server(this, port);
    currentTweet = null;
  }

  currentOverlay.displayMessage("MousePiano.com");
  currentOverlay.displayPlayMe(true);

  setupVisualizer(-1);
}

void setupBusConnection(int inputOverride) {
	// List all available Midi devices on STDOUT. This will show each device's index and name.
	MidiBus.list();

	String[] inputs = MidiBus.availableInputs();
	int likelyInput = 0;

	//	Only search if we haven't been overridden
	if (inputOverride < 0) {
		for (int i=0; i < inputs.length; i++) {
			if (inputs[i].equals("AmeliaTime")) {
				likelyInput = i;
			} else if (inputs[i].equals("VMPK Output")) {
				likelyInput = i;
				break; // Always use VMPK if present. Likely means local development
			}
		}
	} else {
		likelyInput = inputOverride;
	}

	print("Using Input: [" + likelyInput + "] - " + inputs[likelyInput]);

	myBus = new MidiBus(this, likelyInput, 0);
}

void setupVisualizer(int newCurrentID) {
	if (newCurrentID > -1) {
		currentVisualization = newCurrentID;
	}

  lastCycle = millis();

  colorMode(HSB, 100);

  color[][] colorSets = {
    {
      color(0, 100, 100), color(99.9, 100, 100)
    }
    ,
    {
      color(0, 100, 100), color(50, 100, 100)
    }
    ,
    {
      color(50, 100, 100), color(99.9, 100, 100)
    }
    ,
    {
      color(0, 100, 100), color(70, 100, 100)
    }
  };

  colorSetCount = colorSets.length;
  noLights();

  if (currentVisualization < 9) {
    // 1-9 are basic visualziers.
    currentVisualizer = new BasicVisualizer(currentVisualization, colorSets[currentColorSet]);
  } else {
    switch(currentVisualization) {
    case 9:
      currentVisualizer = new BlurryBubbleVisualizer(colorSets[currentColorSet]);
      break;
    case 10:
      currentVisualizer = new DottedLineVisualizer(colorSets[currentColorSet]);
      break;
    case 11:
      currentVisualizer = new VZBowieLines(colorSets[currentColorSet]);
      break;
    case 12:
      currentVisualizer = new VZWisp(colorSets[currentColorSet]);
      break;
    case 13:
      currentVisualizer = new Dictionary(colorSets[currentColorSet]);
      break;
	case 14:
		currentVisualizer = new VZCosmos();
		break;
	case 15:
		currentVisualizer = new VZPointTriangle(colorSets[currentColorSet]);
		break;
	case 16:
		currentVisualizer = new VZRippleWall(colorSets[currentColorSet]);
		break;
	case 17:
		currentVisualizer = new VZGrowBar(colorSets[currentColorSet]);
		break;
	// case xx:
	// 	currentVisualizer = new VZSpiralWeb(colorSets[currentColorSet]);
	// 	break;
    //case xx:
    //  currentVisualizer = new VZVideoGrid(colorSets[currentColorSet], this);
    //  break;
    default:
      break;
    }
  }

  setup = true;
}

void draw() {
  currentVisualizer.clear(currentVisualization);
  currentVisualizer.update();
  currentOverlay.update();

  if (tweet) {
    Client thisClient = myServer.available();

    if (thisClient !=null) {
      String whatClientSaid = thisClient.readString();
      if (whatClientSaid != null) {
        if (finalString != null) {
          finalString += whatClientSaid;
        } else {
          finalString = whatClientSaid;
        }

        //println(thisClient.ip() + ": " + whatClientSaid);
      }
    } else {

      if (finalString != null) {
        if (finalString.indexOf("<b>") != -1) {
          //incomingText = finalString;
          //textDelay = 150;
        } else {
          currentTweet = new Tweet(finalString);
        }

        finalString = null;
      } else if (currentTweet != null) {
        if (currentTweet.intensity == 0) {
          currentTweet = null;
        } else {
          currentTweet.draw();
        }
      } else {
      }
    }
  }

  if (cycleVisualizers) {
    if (millis() > lastCycle + (cycleTime * 1000)) {
      if (currentVisualization < totalVisualizers) {
        currentVisualization++;
      } else {
        currentVisualization = 0;
      }

      setupVisualizer(-1);
    }
  }

  delay(currentVisualizer.delay);
}

void keyPressed() {
  if (key == '1') {
    setupVisualizer(0);
  } else if (key == '2') {
    setupVisualizer(1);
  } else if (key == '3') {
    setupVisualizer(2);
  } else if (key == '4') {
    setupVisualizer(3);
  } else if (key == '5') {
    setupVisualizer(4);
  } else if (key == '6') {
    setupVisualizer(5);
  } else if (key == '7') {
    setupVisualizer(6);
  } else if (key == '8') {
    setupVisualizer(7);
  } else if (key == '9') {
    setupVisualizer(8);
  } else if (key == '0') {
    setupVisualizer(9);
  } else if (key == '-' && (currentVisualization > 0)) {
  	setupVisualizer(currentVisualization - 1);
  } else if (key == '=' && (currentVisualization < totalVisualizers)) {
	  setupVisualizer(currentVisualization + 1);
  } else if (key == 'c') {
    if (currentColorSet == colorSetCount-1) {
      currentColorSet = 0;
    } else {
      currentColorSet++;
    }
    setupVisualizer(-1);
  } else if (key == 'a') {
	currentOverlay.setTextSize(100);
	currentOverlay.displayMessage("Tweet requests to @mousepiano");
  } else if (key == ' ') {
    currentOverlay.displayMessage(" ");
  } else if (key == 'd') {
    currentOverlay.displayPlayMe(!currentOverlay.showPlayMe);
  } else if (key == 'k') {
    cycleVisualizers = !cycleVisualizers;
  }
}

void noteOn(int channel, int pitch, int velocity) {
  int variance = 21; // Default 24
  int destObjId;

  if (showMessages) {
    if (velocity != 0) {
      println("On - Channel:"+channel+" Pitch:"+pitch+" Velocity:"+velocity);
    } else {
      println("Off - Channel:"+channel+" Pitch:"+pitch+" Velocity:"+velocity);
    }
  }

  destObjId = pitch - variance;

  if (destObjId >= 88) {
    destObjId = 87;
  } else if (destObjId <= 0) {
    destObjId = 0;
  }

  if (setup) {
    if (velocity > 0) {
      currentVisualizer.setItemIdActive(destObjId, true);
      currentVisualizer.ping(destObjId, velocity);
    } else {
      currentVisualizer.setItemIdActive(destObjId, false);
      currentVisualizer.pong(destObjId);
    }

    currentOverlay.ping(velocity);
  }
}

void noteOff(int channel, int pitch, int velocity) {
  noteOn(channel, pitch, 0);
  currentOverlay.ping(velocity);
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  if (showMessages) {
    println("Controller Change: Channel:"+channel+" Number:"+number+" Value:"+value);
  }

	switch(number) {
		case 1:
			// Hue is based on the modulation wheel
			gHue = value * 2; break;
		case 2:
			// Pattern is based on the breath expression channel
			if (value < totalVisualizers) {
			setupVisualizer(value);
			}
			break;
		case 3:
			// Use channel 3 to show the requests message
			if (value > 0) {
				currentOverlay.setTextSize(100);
				currentOverlay.displayMessage("Tweet requests to @mousepiano");
			}
			break;
		case 64:
			if (value > 0) {
				sustain = true;
			} else {
				sustain = false;
			}
			break;
		case 123:
			// When the song is over reset the visualizer.
			currentVisualizer.setAllItemsInactive();
			break;
	}
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}

void stop() {
  if (tweet) {
    jmdns.unregisterService(pairservice);
    jmdns.unregisterAllServices();

    try {
      jmdns.close();
    }
    catch (IOException e) {
      e.printStackTrace();
    }
  }
}

public PImage DecodePImageFromBase64(String i_Image64) throws IOException {
  PImage result = null;
  byte[] decodedBytes = Base64.decodeBase64(i_Image64);

  ByteArrayInputStream in = new ByteArrayInputStream(decodedBytes);
  BufferedImage bImageFromConvert = ImageIO.read(in);
  BufferedImage convertedImg = new BufferedImage(bImageFromConvert.getWidth(), bImageFromConvert.getHeight(), BufferedImage.TYPE_INT_ARGB);
  convertedImg.getGraphics().drawImage(bImageFromConvert, 0, 0, null);
  result = new PImage(convertedImg);

  return result;
}
