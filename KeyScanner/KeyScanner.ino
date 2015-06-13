
#define FASTADC 1

// defines for setting and clearing register bits
#ifndef cbi
#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
#endif
#ifndef sbi
#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))
#endif

byte keyVelocity[88]; // 704 bits
byte keyStatus[22]; // 176 bits

// Each keyVelocity has these bits
// delayTime = 0-127 for velocity (7 bits)
// down = boolean if key is down

// Each keyStatus has info for 4 keys
// goingDown = boolean for downward motion
// sent = if midi message sent

byte s0 = 8;
byte s1 = 9;
byte s2 = 10;
byte s3 = 11;

byte controlPins[4] = {s0, s1, s2, s3};

byte muxChannel[8] = {
  B00001000, // Channel 0 & 1
  B01001100, // Channel 2 & 3
  B00101010, // Channel 4 & 5
  B01101110, // Channel 6 & 7
  B00011001, // Channel 8 & 9
  B01011101, // Channel 10 & 11
  B00111011, // Channel 12 & 13
  B01111111  // Channel 14 & 15
};

void setup() {

#if FASTADC
  // set prescale to 16
  sbi(ADCSRA, ADPS2) ;
  cbi(ADCSRA, ADPS1) ;
  cbi(ADCSRA, ADPS0) ;
#endif

  pinMode(s0, OUTPUT);
  pinMode(s1, OUTPUT);
  pinMode(s2, OUTPUT);
  pinMode(s3, OUTPUT);

  digitalWrite(s0, LOW);
  digitalWrite(s1, LOW);
  digitalWrite(s2, LOW);
  digitalWrite(s3, LOW);

  Serial.begin(115200);
}

void loop() {
  for (byte m = 0; m < 16; m++) {
    switchToChannel(m);

    for (byte i = 0; i < 6; i++) {
      byte key = (i * 16) + m;

      // Don't read the end of the last board
      if (key < 88) {
        byte keyPosition = map(analogRead(i), 30, 1010, 0, 255);

        if (keyPosition < 200) {
          if (!downStateForKey(key)) {
            // setGoingDownStateForKey(true, key)
            setKeyPosition(key, getKeyPosition(key) + 1);

            if (keyPosition < 10) {
              setDownStateForKey(true, key);
              setSentStateForKey(false, key);
            }
          } else {
            if (keyPosition > 10) {
              // setGoingDownStateForKey(false, key);
              setDownStateForKey(false, key);
              setSentStateForKey(false, key);
            }
          }
        }

        if (downStateForKey(key)) {
          if (!sentStateForKey(key)) {
            // Send MIDI Note ON with velocity
            setSentStateForKey(true, key);
            setKeyPosition(key, 0);
            setDownStateForKey(true, key);
          }
        } else {
          if (!sentStateForKey(key)) {
            // Send MIDI Note Off
            setSentStateForKey(true, key);
          }
        }
      }
    }
  }
}

void switchToChannel(byte channel) {
  byte block = muxChannel[abs(channel / 2)];

  for (byte i = 0; i < 4; i++) {
    if (channel % 2 == 0) {
      digitalWrite(controlPins[i], bitRead(block, 7 - i));
    } else {
      digitalWrite(controlPins[i], bitRead(block, 3 - i));
    }
  }
}

boolean goingDownStateForKey(byte key) {
  byte block = abs(key / 4); // key=87, block = 21
  byte section = key - (block * 4) - 1; // key = 87, section = 2

  return bitRead(keyStatus[block], (section * 2));
}

void setGoingDownStateForKey(boolean state, byte key) {
  byte block = abs(key / 4); // key=87, block = 21
  byte section = key - (block * 4) - 1; // key = 87, section = 2

  if (state) {
    bitSet(keyStatus[block], (section * 2));
  } else {
    bitClear(keyStatus[block], (section * 2));
  }
}

boolean sentStateForKey(byte key) {
  byte block = abs(key / 4); // key=87, block = 21
  byte section = key - (block * 4) - 1; // key = 87, section = 2

  return bitRead(keyStatus[block], (section * 2) + 1);
}

void setSentStateForKey(boolean state, byte key) {
  byte block = abs(key / 4); // key=87, block = 21
  byte section = key - (block * 4) - 1; // key = 87, section = 2

  if (state) {
    bitSet(keyStatus[block], (section * 2) + 1);
  } else {
    bitClear(keyStatus[block], (section * 2) + 1);
  }
}

boolean downStateForKey(byte key) {
  // Return whether down state bit is true
  return ((keyVelocity[key] & 1) == 1);
}

void setDownStateForKey(boolean state, byte key) {
  if (state) {
    bitSet(keyVelocity[key], 0);
  } else {
    bitClear(keyVelocity[key], 0);
  }
}

byte getKeyPosition(byte key) {
  // Shift off the down state and return number
  return keyVelocity[key] >> 1;
}

void setKeyPosition(byte key, byte keyPosition) {
  byte down = keyVelocity[key] & 1; // Get down state from byte
  keyPosition = keyPosition << 1; // Shift keyPosition to make room for down state
  keyVelocity[key] == (keyPosition | down); // Merge keyPosition and down state
}
