// Hardware: Mega 2560 R2 + Ethernet Shield

#if defined(ARDUINO) && ARDUINO > 18
#include <SPI.h>a
#endif

#include <Ethernet.h>
#include "AppleMidi.h"
#include "Key.h"

// Enter a MAC address for your controller below.
// Newer Ethernet shields have a MAC address printed on a sticker on the shield
byte mac[] = {
  0x90, 0xA2, 0xDA, 0x0F, 0xBB, 0x36
};

#define SER_Pin 5    // Serial Input SER (18 on chip)
#define RCK_Pin 6    //RCLK (7 on chip)
#define SRCK_Pin 7   //SRCLK (8 on chip)
#define SRCLR_Pin 8

//How many of the shift registers & pins
#define controllers 11
#define numOfRegisterPins controllers * 8

boolean showMessages = false;

class Key;
Key pianoKeys[numOfRegisterPins];

// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
void setup() {
  pinMode(SER_Pin, OUTPUT);
  pinMode(RCK_Pin, OUTPUT);
  pinMode(SRCK_Pin, OUTPUT);
  pinMode(SRCLR_Pin, OUTPUT);

  // Serial communications and wait for port to open:
  Serial.begin(115200);
  Serial.print("Getting IP...");

  if (Ethernet.begin(mac) == 0) {
    Serial.println();
    Serial.println( "Failed DHCP!" );
    for (;;)
      ;
  }

  // print your local IP address:
  Serial.println();
  Serial.print("IP: ");
  for (byte thisByte = 0; thisByte < 4; thisByte++) {
    // print the value of each byte of the IP address:
    Serial.print(Ethernet.localIP()[thisByte], DEC);
    Serial.print(".");
  }

  // Create a session and wait for a remote host to connect to us
  AppleMIDI.begin("test");

  // Actively connect to a remote host
  // IPAddress host(192, 168, 2, 1);
  // AppleMIDI.Invite(host, 5004);

  AppleMIDI.OnConnected(OnAppleMidiConnected);
  AppleMIDI.OnDisconnected(OnAppleMidiDisconnected);

  AppleMIDI.OnReceiveNoteOn(OnAppleMidiNoteOn);
  AppleMIDI.OnReceiveNoteOff(OnAppleMidiNoteOff);
  AppleMIDI.OnReceiveControlChange(OnAppleMidiControlChange);

  digitalWrite(SRCLR_Pin, HIGH);

  //reset all register pins
  clearRegisters();
}

// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
void loop() {
  // Listen to incoming notes
  AppleMIDI.run();
  writeRegisters();
  delay(20);
}

// ====================================================================================
// Event handlers for incoming MIDI messages
// ====================================================================================

void OnAppleMidiConnected(char* name) {
  Serial.print("C: ");
  Serial.println(name);
}

void OnAppleMidiDisconnected() {
  Serial.println("D");
  clearRegisters();
}

void OnAppleMidiControlChange(byte channel, byte number, byte value) {
  if (number == 123) {
    clearRegisters();
    delay(20);
  }
}

void OnAppleMidiNoteOn(byte channel, byte note, byte velocity) {
  byte destObjId = note-21;

  if (destObjId >= 88) { 
    destObjId = 87;
  } 
  else if (destObjId < 0) { 
    destObjId = 0;
  }

  if (velocity > 0) {
    pianoKeys[destObjId].channelOn(channel);
  } 
  else {
    pianoKeys[destObjId].channelOff(channel);
  }
}

void OnAppleMidiNoteOff(byte channel, byte note, byte velocity) {
  byte destObjId = note-24;

  if (destObjId >= 88) { 
    destObjId = 87;
  } 
  else if (destObjId < 0) { 
    destObjId = 0;
  }

  pianoKeys[destObjId].channelOff(channel);
}

//set all register pins to LOW
void clearRegisters() {
  // All Notes Off
  for (int i=0; i < numOfRegisterPins; i++) {
    pianoKeys[i].allOff();
  }
}

//Set and display registers
//Only call AFTER all values are set how you would like (slow otherwise)
void writeRegisters() {
  int shift = 0;
  byte x = 0;
  byte currentNote = 0;

  digitalWrite(RCK_Pin, LOW);

  for (int i = 0; i < controllers; i++) {
    if (showMessages && i == 0) {
       pianoKeys[0].printTimeLine(); 
    }
    
    for (int x = 0; x < 8; x++) {
        bitWrite(shift, x, pianoKeys[currentNote+x].isOn());
        pianoKeys[currentNote+x].decay();
    }

    shiftOut(SER_Pin, SRCK_Pin, MSBFIRST, shift);
    shift = 0;
    currentNote += 8;
  }

  digitalWrite(RCK_Pin, HIGH);
}

