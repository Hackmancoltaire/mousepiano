final float keys = 88.0;

import themidibus.*; //Import the library
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
VisualItem[] visualItems = new VisualItem[88];
boolean showMessages = false;

boolean cycleVisualizers = true;
int lastCycle = millis();
int currentVisualization = 0;
int totalVisualizers = 13;
Visualizer currentVisualizer;

boolean sustain = false;
boolean setup = false;
int screenWidth = 1920;
int screenHeight = 540;

boolean[] activeKeys = new boolean[88];

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

Overlay currentOverlay = new Overlay();

int gHue = 0;

void setup() {
  //fullScreen(P3D);
  size(1920, 1080, P3D);

  standardFont = createFont("Desdemona", 128, true);

  noCursor();
  background(0);

  if (showMessages) {
    MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  }

  myBus = new MidiBus(this, 1, 1); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.

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
  setupVisualizer();
}

void setupVisualizer() {
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
      //case 14:
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

  for (int i=0; i < keys; i++) {
    currentVisualizer.update(i);
  }

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
    if (millis() > lastCycle + 60000) {
      if (currentVisualization < totalVisualizers) {
        currentVisualization++;
      } else {
        currentVisualization = 0;
      }

      setupVisualizer();
    }
  }

  delay(currentVisualizer.delay);
}

void keyPressed() {
  if (key == '1') {
    currentVisualization = 0;
    setupVisualizer();
  } else if (key == '2') {
    currentVisualization = 1;
    setupVisualizer();
  } else if (key == '3') {
    currentVisualization = 2;
    setupVisualizer();
  } else if (key == '4') {
    currentVisualization = 3;
    setupVisualizer();
  } else if (key == '5') {
    currentVisualization = 4;
    setupVisualizer();
  } else if (key == '6') {
    currentVisualization = 5;
    setupVisualizer();
  } else if (key == '7') {
    currentVisualization = 6;
    setupVisualizer();
  } else if (key == '8') {
    currentVisualization = 7;
    setupVisualizer();
  } else if (key == '9') {
    currentVisualization = 8;
    setupVisualizer();
  } else if (key == '0') {
    currentVisualization = 9;
    setupVisualizer();
  } else if (key == '-') {
    if (currentVisualization > 0) {
      currentVisualization -= 1;
      setupVisualizer();
    }
  } else if (key == '=') {
    if (currentVisualization < totalVisualizers) {
      currentVisualization++;
      setupVisualizer();
    }
  } else if (key == 'c') {
    if (currentColorSet == colorSetCount-1) {
      currentColorSet = 0;
    } else {
      currentColorSet++;
    }
    setupVisualizer();
  } else if (key == 'a') {
    currentOverlay.displayMessage("Would you like hear a song?");
  } else if (key == ' ') {
    currentOverlay.displayMessage("");
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
      currentVisualizer.ping(destObjId);
    } else {
      currentVisualizer.setItemIdActive(destObjId, false);
      currentVisualizer.pong(destObjId);
    }

    currentOverlay.ping();
  }
}

void noteOff(int channel, int pitch, int velocity) {
  noteOn(channel, pitch, 0);
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  if (showMessages) {
    println("Controller Change: Channel:"+channel+" Number:"+number+" Value:"+value);
  }

  // Hue is based on the modulation wheel
  if (number == 1) {
    gHue = value * 2;
  }

  // Pattern is based on the breath expression channel
  else if (number == 2) {
    if (value < totalVisualizers) {
      currentVisualization = value;
      setupVisualizer();
    }
  }

  // All Notes Off
  if (number == 123) {
    // When the song is over reset the visualizer.
    currentVisualizer.setAllItemsInactive();
  }
  // Sustain pedal
  else if (number == 64) {
    if (value > 0) {
      sustain = true;
    } else {
      sustain = false;
    }
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