#include <SPI.h>
#include <Ethernet.h>
#include <MemoryFree.h>
#include <avr/wdt.h>

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
boolean sustain = false;

// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------

APPLEMIDI_CREATE_DEFAULT_INSTANCE();

void setup() {
  pinMode(SER_Pin, OUTPUT);
  pinMode(RCK_Pin, OUTPUT);
  pinMode(SRCK_Pin, OUTPUT);
  pinMode(SRCLR_Pin, OUTPUT);

  // Serial communications and wait for port to open:
  Serial.begin(115200);
  Serial.print(F("DHCP IP: "));

  if (Ethernet.begin(mac) == 0) {
    Serial.println(F("FAILED"));
    for (;;)
      ;
  }

  // IP Address
  Serial.println(Ethernet.localIP());

  // Create a session and wait for a remote host to connect to us
  AppleMIDI.begin("MousePiano");

  // Setup AppleMIDI Callbacks
  AppleMIDI.OnConnected(OnAppleMidiConnected);
  AppleMIDI.OnDisconnected(OnAppleMidiDisconnected);

  AppleMIDI.OnReceiveNoteOn(OnAppleMidiNoteOn);
  AppleMIDI.OnReceiveNoteOff(OnAppleMidiNoteOff);
  AppleMIDI.OnReceiveControlChange(OnAppleMidiControlChange);

  digitalWrite(SRCLR_Pin, HIGH);

  // Reset all register pins
  clearRegisters();
  
  // Show available memory
  Serial.print(F("Available Memory: "));
  Serial.println(freeMemory());
  
  // Enable the watchdog timer
  wdt_enable(WDTO_1S);
}

// -----------------------------------------------------------------------------

void loop() {
  // Reset watchdog timer
  wdt_reset();
  
  // Listen to incoming notes
  AppleMIDI.run();
  writeRegisters();
  delay(20);
}

// ====================================================================================
// Event handlers for incoming MIDI messages
// ====================================================================================

void OnAppleMidiConnected(long unsigned int ssrc, char* name) {
  Serial.print(F("C: "));
  Serial.println(name);
}

void OnAppleMidiDisconnected(long unsigned int ssrc) {
  Serial.println(F("D"));
  clearRegisters();
}

void OnAppleMidiControlChange(byte channel, byte number, byte value) {
  // All Notes Off
  if (number == 123) {
    Serial.println(F("Received All Notes Off"));
    clearRegisters();
    Serial.print(F("Available Memory: "));
    Serial.println(freeMemory());
    delay(20);
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

void OnAppleMidiNoteOn(byte channel, byte note, byte velocity) {
  if (channel != 10) {
    byte destObjId = note-21;
  
    if (destObjId >= 88) { 
      destObjId = 87;
    } 
    else if (destObjId < 0) { 
      destObjId = 0;
    }
  
    if (velocity > 0) {
      pianoKeys[destObjId].channelOn(channel);
  
      if (showMessages) {
        Serial.print(F("NoteOn: "));
        Serial.println(destObjId);
      }
    } 
  //  else {
  //    pianoKeys[destObjId].channelOff(channel);
  //
  //    if (showMessages) {
  //      Serial.print("NoteOff: ");
  //      Serial.println(destObjId);
  //    }
  //  }
  }
}

void OnAppleMidiNoteOff(byte channel, byte note, byte velocity) {
  if (channel != 10) {
    byte destObjId = note-21;
  
    if (destObjId >= 88) { 
      destObjId = 87;
    } 
    else if (destObjId < 0) { 
      destObjId = 0;
    }
  
    pianoKeys[destObjId].channelOff(channel);
  
    if (showMessages) {
      Serial.print(F("NoteOff: "));
      Serial.println(destObjId);
    }
  }
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
        bitWrite(shift, x, pianoKeys[currentNote+x].isOn(sustain));
        pianoKeys[currentNote+x].decay();
    }

    shiftOut(SER_Pin, SRCK_Pin, MSBFIRST, shift);
    shift = 0;
    currentNote += 8;
  }

  digitalWrite(RCK_Pin, HIGH);
}

