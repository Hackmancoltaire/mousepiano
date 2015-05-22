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

MidiBus myBus; // The MidiBus
VisualItem[] visualItems = new VisualItem[88];
float keys = 88.0;
boolean showMessages = false;

int currentVisualization = 9;
boolean setup = false;
int screenWidth = 1920;
int screenHeight = 540;

String incomingText = "";
int textDelay = 0;
PFont standardFont = createFont("Helvetica", 64);

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
  size(screenWidth, screenHeight, P3D);
  noCursor();
  background(0);

  if (showMessages) {
    MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  }

  myBus = new MidiBus(this, 2, 1); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.

  incomingText = "Welcome to my Piano!";
  textDelay = 50;

  if (frame.isUndecorated()) { 
    thread("repositionCanvas");
  }

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

  setupVisualizer();
}

void repositionCanvas() {
  while (!frame.isVisible ())  delay(2);
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

  float increment = width / keys;
  color startColor = colorSets[currentColorSet][0];
  color endColor = colorSets[currentColorSet][1];

  // One Time Setup
  switch(currentVisualization) {
  default:
    noLights();
    break;
  }

  // Object setups
  for (int i=0; i < keys; i++) {
    float lerpAmount = (1/keys) * i;

    switch(currentVisualization) {
    case 0:
      visualItems[i] = new Bar(increment, increment*i, lerpColor(startColor, endColor, lerpAmount));
      break;
    case 1:
      visualItems[i] = new BouncingBall(increment*i + (width / keys)/2, height, lerpColor(startColor, endColor, 0.01 * i), screenWidth / keys);
      break;
    case 2:
      visualItems[i] = new ColorCube(i, lerpColor(startColor, endColor, lerpAmount));
      break;
    case 3:
      visualItems[i] = new LineTree(i, lerpColor(startColor, endColor, 0.01 * i));
      break;
    case 4:
      visualItems[int(keys - 1 - i)] = new Ring(i, keys, lerpColor(startColor, endColor, lerpAmount));
      break;
    case 5:
      visualItems[i] = new Dictionary(i, activeKeys, lerpColor(startColor, endColor, 0.01 * i));
      break;
    case 6:
      visualItems[i] = new RippleTriangle(i, lerpColor(startColor, endColor, 0.01 * i));
      break;
    case 7:
      visualItems[i] = new TriangleNoise(lerpColor(startColor, endColor, 0.01 * i));
      break;
    case 8:
      visualItems[i] = new RoamingLine(lerpColor(startColor, endColor, 0.01 * i));
      break;
    case 9:
      visualItems[i] = new ColoredSlash(lerpColor(startColor, endColor, 0.01 * i));
      break;
    }
  }

  setup = true;
}

void draw() {
  colorMode(RGB, 255);
  noStroke();
  //translate(0, -270);

  switch(currentVisualization) {
  case 3:
    fill(0);
    break;
  case 5:
    fill(0, 0, 0, 180);
    delay(100);
    break;  
  case 7:
    fill(0, 0, 0, 10);
    break;
  case 8:
    fill(0, 0, 0, 20);
    break;
  case 9:
    fill(0, 0, 0, 70);
    break;
  default:
    fill(0, 0, 0, 40);
    break;
  }

  rect(0, 0, width, height);

  for (int i=0; i < keys; i++) {
    visualItems[i].update();
  }

  if (textDelay > 0) {
    fill(255, 255, 255);
    textFont(standardFont);
    textSize(64);
    textAlign(CENTER);
    text(incomingText, screenWidth/2, screenHeight/2);
    textDelay -= 1;
  }

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

  delay(25);
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
  }
}

void noteOn(int channel, int pitch, int velocity) {
  if (showMessages) {
    println("On - Channel:"+channel+" Pitch:"+pitch+" Velocity:"+velocity);
  }

  int destObjId = pitch-24;

  if (destObjId >= 88) { 
    destObjId = 87;
  } else if (destObjId <= 0) { 
    destObjId = 0;
  }

  if (setup) {
    if (velocity > 0) {
      activeKeys[destObjId] = true;
      visualItems[destObjId].ping();
    } else {
      activeKeys[destObjId] = false;
      visualItems[destObjId].pong();
    }
  }
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  if (showMessages) {
    println("Off - Channel:"+channel+" Pitch:"+pitch+" Velocity:"+velocity);
  }

  int destObjId = pitch-24;

  if (destObjId >= 88) { 
    destObjId = 87;
  } else if (destObjId <= 0) { 
    destObjId = 0;
  }

  if (setup) {
    activeKeys[destObjId] = false;
    visualItems[destObjId].pong();
  }
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  if (showMessages) {
    println("Controller Change: Channel:"+channel+" Number:"+number+" Value:"+value);
  }
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}

void stop() {
  jmdns.unregisterService(pairservice);
  jmdns.unregisterAllServices();

  try {
    jmdns.close();
  } 
  catch (IOException e) {
    e.printStackTrace();
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

