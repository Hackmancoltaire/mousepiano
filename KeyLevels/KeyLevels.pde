import processing.serial.*;

Serial myPort;  // Create object from Serial class
boolean showMessages = true;
boolean setup = false;
int screenWidth = 1920;
int screenHeight = 540;
int val;      // Data received from the serial port
int lf = 10;    // Linefeed in ASCII
boolean down = false;
int noteDown = 0;

int keys = 88;

int currentColorSet = 1;

int currentVisualization = 0;
Visualizer currentVisualizer;


void setup() {
 // colorMode(HSB, 100);

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


  size(1920, 540, P3D);
  myPort = new Serial(this, "/dev/tty.usbmodem1411", 115200);

  currentVisualizer = new BasicVisualizer(currentVisualization, colorSets[currentColorSet]);
}

String[] values = new String[88];

void draw() {
  background(0);             // Set background to white


  if ( myPort.available() > 0) {  // If data is available,
    String temp = myPort.readStringUntil(lf);
    String[] tempValues;

    if (temp != null) {
      tempValues = split(temp, ",");

      if (tempValues != null) {
        for (int i=0; i < tempValues.length && i < keys; i++) {
          if (tempValues[i] != null) {
            String[] tempVal = split(tempValues[i], ":");

            if (tempVal.length == 3) {
              if (tempVal[0] != null && tempVal[1] != null && tempVal[2] != null) {
                values[int(tempVal[0])] = tempVal[1];
                
                if (values[i] != null) {
                  currentVisualizer.setValue(i, int(trim(values[i])));
                }
                
                if (int(tempVal[2]) == 0) {
                  currentVisualizer.pong(int(tempVal[0]));
                } else {
                  currentVisualizer.ping(int(tempVal[0]));
                }
              }
            }
          }

          
        }
      }
    }
  }

  for (int i=0; i < keys; i++) {
    currentVisualizer.update(i);
  }
}