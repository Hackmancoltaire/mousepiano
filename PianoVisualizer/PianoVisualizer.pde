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

int currentVisualization = 14;
Visualizer currentVisualizer;

boolean sustain = false;
boolean setup = false;
int screenWidth = 1920;
int screenHeight = 540;

String incomingText = "";
int textDelay = 0;
PFont standardFont;

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

Tweet currentTweet;

void setup() {
  size(1920, 540, P3D);
  standardFont = createFont("Helvetica", 64);
  noCursor();
  background(0);

  if (showMessages) {
    MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  }

  myBus = new MidiBus(this, 2, 1); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.

  incomingText = "MousePiano.com";
  textDelay = 50;

  if (frame.isUndecorated()) {
    thread("repositionCanvas");
  }

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

  setupVisualizer();
}

void repositionCanvas() {
  while (!frame.isVisible ()) {
    delay(2);
  }
  frame.setSize(1920, 540);
  frame.setLocation(0, -270);
}

void setupVisualizer() {
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

  // One Time Setup
  switch(currentVisualization) {
  default:
    noLights();
    break;
  }

  if (currentVisualization < 9) {
    // 1-9 are basic visualziers.
    currentVisualizer = new BasicVisualizer(currentVisualization, colorSets[currentColorSet]);
  } else {
    switch(currentVisualization) {
    case 9:
      currentVisualizer = new BlurryBubbleVisualizer(colorSets[currentColorSet]); break;
    case 10:
      currentVisualizer = new DottedLineVisualizer(colorSets[currentColorSet]); break;
    case 11:
      currentVisualizer = new VZBowieLines(colorSets[currentColorSet]); break;
    case 12:
      currentVisualizer = new VZVideoGrid(colorSets[currentColorSet], this); break;
    case 13:
      currentVisualizer = new VZWisp(colorSets[currentColorSet]); break;
	case 14:
		currentVisualizer = new Dictionary(colorSets[currentColorSet]); break;
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

  if (textDelay > 1) {
    colorMode(RGB, 255);
    fill(255, 255, 255);
    textFont(standardFont);
    textSize(64);
    textAlign(CENTER);
    text(incomingText, screenWidth/2, screenHeight/2);
    textDelay -= 1;
  }

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
          incomingText = finalString;
          textDelay = 150;
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
    currentVisualization -= 1;
    setupVisualizer();
  } else if (key == '=') {
    currentVisualization++;
    setupVisualizer();
  } else if (key == 'c') {
    if (currentColorSet == colorSetCount-1) {
      currentColorSet = 0;
    } else {
      currentColorSet++;
    }
    setupVisualizer();
  } else if (key == 'a') {
    incomingText = "Would you like hear a song?";
    textDelay = 150;
  } else if (key == 'c') {
    incomingText = "";
  } else if (key == 'r') {
    currentVisualizer.clear(0);
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

  // All Notes Off
  if (number == 123) {
    // When the song is over reset the visualizer.
    currentVisualizer.clear(0);
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
