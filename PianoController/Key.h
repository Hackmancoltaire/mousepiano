#define noteLife 5

class Key {
private:
  byte currentDecay;
  long timeLine; //32 bits

public:
  Key() {
    currentDecay = 0;
    clearArray();
  }

  void channelOn(int channel) {
    if (currentDecay > 0) {
      currentDecay = 0;
      clearArray();
      shiftArray(true);
    }
   
    if (bitRead(timeLine, 0) == false) {
      shiftArray(true);
    }
  }

  void channelOff(int channel) {
    currentDecay = noteLife;
    shiftArray(false);
  }

  void allOff() {
    clearArray();
    currentDecay = 0;
  }

  void decay() {
    if (currentDecay > 0) {
      currentDecay -= 1;
    } else {
      currentDecay = 0; 
    }

    shiftArray(bitRead(timeLine, 0));
  }

  boolean isReady() {
    return true;
  }

  boolean isOn() {
    return bitRead(timeLine, (sizeof(timeLine) - 1));
  }

  void shiftArray(boolean newValue) {
    timeLine = timeLine << 1;
    bitWrite(timeLine, 0, newValue);
  }

  void clearArray() {
    timeLine = 0;
  }
  
  void printTimeLine() {
    Serial.println(timeLine, BIN);
  }
};
