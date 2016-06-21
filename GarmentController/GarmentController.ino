#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <WiFiUdp.h>
#include <Esp.h>
#include <MemoryFree.h>

#define FASTLED_ESP8266_RAW_PIN_ORDER // Necessary for the ESP8266 (Sparkfun Thing)

#include "FastLED.h"
#include "AppleMidi.h"
#include "Key.h"

//char ssid[] = "U.S.S. Riverton"; //  your network SSID (name)
//char pass[] = "intrepidcrew";    // your network password (use for WPA, or use as key for WEP)

char ssid[] = "AmeliaNet"; //  your network SSID (name)
char pass[] = "ilovemusic";    // your network password (use for WPA, or use as key for WEP)


#define showMessages true

#define KEYCOUNT 88
#define TRANSPOSE 21

class Key;
Key pianoKeys[KEYCOUNT];
boolean sustain = false;

// FastLED

#if FASTLED_VERSION < 3001000
#error "Requires FastLED 3.1 or later; check github for latest code."
#endif

#define DATA_PIN    4
#define LED_TYPE    WS2812
#define COLOR_ORDER GRB

#define NUM_LEDS    150
#define SECTIONS    7
#define PERSECTION  21 // 124/7 round up!
CRGB leds[NUM_LEDS];

#define BRIGHTNESS          96
#define FRAMES_PER_SECOND  120

// -----------------------------------------------------------------------------

APPLEMIDI_CREATE_INSTANCE(WiFiUDP, AppleMIDI); // see definition in AppleMidi_Defs.h

int gHue = 0;
int currentPattern = 0;

void setup() {
  // Serial communications and wait for port to open:
  Serial.begin(74880);

  while (!Serial) {
    ; // wait for serial port to connect.
  }

  Serial.print("Connecting to Wifi");

  WiFi.begin(ssid, pass);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("Connected!");
  Serial.print(F("DHCP IP: "));
  Serial.println(WiFi.localIP());

  // Create a session and wait for a remote host to connect to us
  AppleMIDI.begin("Garment");

  // Actively connect to a remote host
  IPAddress remote(10, 0, 0, 4);
  AppleMIDI.invite(remote, 5004);

  // Setup AppleMIDI Callbacks
  AppleMIDI.OnConnected(OnAppleMidiConnected);
  AppleMIDI.OnDisconnected(OnAppleMidiDisconnected);

  AppleMIDI.OnReceiveNoteOn(OnAppleMidiNoteOn);
  AppleMIDI.OnReceiveNoteOff(OnAppleMidiNoteOff);
  AppleMIDI.OnReceiveControlChange(OnAppleMidiControlChange);

  delay(3000); // 3 second delay for FastLED recovery

  // tell FastLED about the LED strip configuration
  FastLED.addLeds<LED_TYPE, DATA_PIN, COLOR_ORDER>(leds, NUM_LEDS).setCorrection(TypicalLEDStrip);
  //FastLED.addLeds<LED_TYPE,DATA_PIN,CLK_PIN,COLOR_ORDER>(leds, NUM_LEDS).setCorrection(TypicalLEDStrip);

  // set master brightness control
  FastLED.setBrightness(BRIGHTNESS);
  fadeToBlackBy(leds, NUM_LEDS, 5);

  for (int i = 0; i < KEYCOUNT; i++) {
    pianoKeys[i].setId(i);
  }
}

// -----------------------------------------------------------------------------

typedef void (*PatternList[])();
PatternList patterns = {
  basic,
  rainbow,
  rainbowWithGlitter,
  confetti,
  sinelon,
  juggle,
  bpm,
  noteSections,
  //newDrop
};

void loop() {
  // Listen to incoming notes
  AppleMIDI.run();
  yield();

  patterns[currentPattern]();

  FastLED.show();
}

// ====================================================================================
// Event handlers for incoming MIDI messages
// ====================================================================================

void OnAppleMidiConnected(uint32 ssrc, char* name) {
  Serial.print(F("C: "));
  Serial.println(name);
}

void OnAppleMidiDisconnected(uint32 ssrc) {
  Serial.println(F("D"));
}

void OnAppleMidiControlChange(byte channel, byte number, byte value) {
  // Hue is based on the modulation wheel
  if (number == 1) {
    gHue = value * 2;
  }

  // Pattern is based on the breath expression channel
  else if (number == 2) {
    if (value < sizeof(patterns) - 1) {
      currentPattern = value;
    }
  }

  // All Notes Off
  else if (number == 123) {
    Serial.println(F("Received All Notes Off"));
    // Should make all lights go dark. Or set the pattern to just fade to black.
  }

  // Sustain pedal
  else if (number == 64) {
    if (value > 0) {
      Serial.println("Set sustain to true");
      sustain = true;
    } else {
      Serial.println("Set sustain to false");
      sustain = false;
    }
  }
}

void OnAppleMidiNoteOn(byte channel, byte note, byte velocity) {
  if (channel != 10) {
    byte destObjId = note - TRANSPOSE;

    if (destObjId >= 88) {
      destObjId = 87;
    }
    else if (destObjId < 0) {
      destObjId = 0;
    }

    if (velocity > 0) {
      pianoKeys[destObjId].channelOn(channel);
      //droplet(map(constrain(destObjId, 0, 88), 0, 88, 0, SECTIONS), PERSECTION / 2);

      if (showMessages) {
        Serial.print(F("NoteOn: "));
        Serial.println(destObjId);
      }
    }
  }
}

void OnAppleMidiNoteOff(byte channel, byte note, byte velocity) {
  if (channel != 10) {
    byte destObjId = note - TRANSPOSE;

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

// ====================================================================================
// Pattern functions
// ====================================================================================

void basic() {
  fadeToBlackBy(leds, NUM_LEDS, 10);

  for (int i = 0; i < KEYCOUNT; i++) {
    if (pianoKeys[i].isOn()) {
      int dest = map(i - 1, 0, KEYCOUNT, 0, NUM_LEDS / 2);

      leds[abs(dest - 1)] += CHSV(gHue, 255, 255);
      leds[dest] += CHSV(gHue, 255, 255);

      if (dest + 1 < NUM_LEDS && dest + 2 < NUM_LEDS) {
        leds[dest + 1] += CHSV(gHue, 255, 255);
      }

      dest = NUM_LEDS - dest;

      leds[abs(dest - 1)] += CHSV(gHue, 255, 255);
      leds[dest] += CHSV(gHue, 255, 255);

      if (dest + 1 < NUM_LEDS && dest + 2 < NUM_LEDS) {
        leds[dest + 1] += CHSV(gHue, 255, 255);
      }
    }
  }
}

void noteSections() {
  CRGB targetColor = CRGB::Red;

  fadeToBlackBy(leds, NUM_LEDS, 10);

  for (int i = 0; i < KEYCOUNT; i++) {
    if (pianoKeys[i].isOn() && pianoKeys[i].note.indexOf("C") > -1) {
      targetColor.setHSV(0, 255, 255);
      lightSectionWithColor(0, targetColor);
    } else if (pianoKeys[i].isOn() && pianoKeys[i].note.indexOf("D") > -1) {
      targetColor.setHSV(42, 255, 255);
      lightSectionWithColor(1, targetColor);
    } else if (pianoKeys[i].isOn() && pianoKeys[i].note.indexOf("E") > -1) {
      targetColor.setHSV(84, 255, 255);
      lightSectionWithColor(2, targetColor);
    } else if (pianoKeys[i].isOn() && pianoKeys[i].note.indexOf("F") > -1) {
      targetColor.setHSV(126, 255, 255);
      lightSectionWithColor(3, targetColor);
    } else if (pianoKeys[i].isOn() && pianoKeys[i].note.indexOf("G") > -1) {
      targetColor.setHSV(168, 255, 255);
      lightSectionWithColor(4, targetColor);
    } else if (pianoKeys[i].isOn() && pianoKeys[i].note.indexOf("A") > -1) {
      targetColor.setHSV(210, 255, 255);
      lightSectionWithColor(5, targetColor);
    } else if (pianoKeys[i].isOn() && pianoKeys[i].note.indexOf("B") > -1) {
      targetColor.setHSV(252, 255, 255);
      lightSectionWithColor(6, targetColor);
    }
    //    else {
    //      if (pianoKeys[i].isOn(sustain)) {
    //        Serial.println("Key Note: " + String(i) + ",  Var: " + pianoKeys[i].note);
    //        Serial.println("Key Note: " + String(i) + ", Func: " + pianoKeys[i].getNote());
    //
    //        int index = ceil(map(i,0,88,0,NUM_LEDS));
    //        leds[index] = CRGB::Red;
    //      }
    //    }
  }
}

void lightSectionWithColor(int section, CRGB color) {
  int high = PERSECTION * (section + 1);
  int low = PERSECTION * section;

  for (int i = low; i < high; i++) {
    leds[i] = color;
  }
}

void newDrop() {
  int high = 0;
  int low = 0;
  int ledIndex = 0;
  int fadePercent = 10;

  fadeToBlackBy(leds, NUM_LEDS, 10);

  for (int i = 0; i < KEYCOUNT; i++) {
    if (pianoKeys[i].isOn()) {
      ledIndex = map(i, 0, KEYCOUNT, 0, NUM_LEDS);
      leds[ledIndex] += CHSV(gHue, 255, 255);

      if (ledIndex + PERSECTION > NUM_LEDS) {
        high = NUM_LEDS;
      }
      else {
        high = ledIndex + PERSECTION;
      }

      if (ledIndex - PERSECTION < 0) {
        low = 0;
      }
      else {
        low = ledIndex - PERSECTION;
      }

      for (int i = 0; i < (high - low); i++) {
        int up = ledIndex + i;
        int down = ledIndex - i;

        if (up < high) {
          if (leds[up].getLuma() == 0) {
            CRGB tempLight = CHSV(gHue, 255, 255);
            tempLight.fadeLightBy((255 * fadePercent) * i);
            leds[up] = tempLight;
          } else {
            leds[down].fadeLightBy((255 * fadePercent) * i);
          }
        }

        if (down > low) {
          if (leds[down].getLuma() == 0) {
            CRGB tempLight = CHSV(gHue, 255, 255);
            tempLight.fadeLightBy((255 * fadePercent) * i);
            leds[down] = tempLight;
          } else {
            leds[down].fadeLightBy((255 * fadePercent) * i);
          }
        }
      }
    }
  }
}

// Increases the intensity of the index and the surrounding
// lights at a lower intensity for the size of the section (PERSECTION)
void droplet(int section, int index) {
  int high = PERSECTION * (section + 1);
  int low = PERSECTION * section;
  int fadePercent = 10;

  leds[(section * PERSECTION) + index] = CRGB::Red;

  for (int i = 0; i < PERSECTION; i++) {
    int up = (section * PERSECTION) + index + i;
    int down = (section * PERSECTION) + index - i;

    if (up < high) {
      if (leds[up].getLuma() == 0) {
        CRGB tempLight = CRGB::Red;
        tempLight.fadeLightBy((255 * fadePercent) * i);
        leds[up] = tempLight;
      } else {
        leds[down].fadeLightBy((255 * fadePercent) * i);
      }
    }

    if (down > low) {
      if (leds[down].getLuma() == 0) {
        CRGB tempLight = CRGB::Red;
        tempLight.fadeLightBy((255 * fadePercent) * i);
        leds[down] = tempLight;
      } else {
        leds[down].fadeLightBy((255 * fadePercent) * i);
      }
    }
  }
}

void rainbow() {
  // FastLED's built-in rainbow generator
  fill_rainbow( leds, NUM_LEDS, gHue, 7);
}

void rainbowWithGlitter() {
  // built-in FastLED rainbow, plus some random sparkly glitter
  rainbow();
  addGlitter(80);
}

void addGlitter( fract8 chanceOfGlitter) {
  if ( random8() < chanceOfGlitter) {
    leds[ random16(NUM_LEDS) ] += CRGB::White;
  }
}

void confetti() {
  // random colored speckles that blink in and fade smoothly
  fadeToBlackBy( leds, NUM_LEDS, 10);
  int pos = random16(NUM_LEDS);
  leds[pos] += CHSV( gHue + random8(64), 200, 255);
}

void sinelon() {
  // a colored dot sweeping back and forth, with fading trails
  fadeToBlackBy( leds, NUM_LEDS, 20);
  int pos = beatsin16(13, 0, NUM_LEDS);
  leds[pos] += CHSV( gHue, 255, 192);
}

void bpm() {
  // colored stripes pulsing at a defined Beats-Per-Minute (BPM)
  uint8_t BeatsPerMinute = 62;
  CRGBPalette16 palette = PartyColors_p;
  uint8_t beat = beatsin8( BeatsPerMinute, 64, 255);
  for ( int i = 0; i < NUM_LEDS; i++) { //9948
    leds[i] = ColorFromPalette(palette, gHue + (i * 2), beat - gHue + (i * 10));
  }
}

void juggle() {
  // eight colored dots, weaving in and out of sync with each other
  fadeToBlackBy( leds, NUM_LEDS, 20);
  byte dothue = 0;
  for ( int i = 0; i < 8; i++) {
    leds[beatsin16(i + 7, 0, NUM_LEDS)] |= CHSV(dothue, 200, 255);
    dothue += 32;
  }
}
