#define noteLife 5

class Key {
  private:
    byte currentDecay;
    long timeLine; //32 bits
    byte shiftDelay = 0;
    boolean isChannelOn = false;
    boolean sustain = false;
    boolean shouldSustain = false;

  public:
    Key() {
      currentDecay = 0;
      clearArray();
    }

    void channelOn(int channel) {
      isChannelOn = true;

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
      isChannelOn = false;

      if (shouldSustain) {
       sustain = true;
      } else {
       sustain = false;
      }

      currentDecay = noteLife;
      shiftArray(false);
    }

    void allOff() {
      isChannelOn = false;
      sustain = false;

      clearArray();
      currentDecay = 0;
    }

    void decay() {
      if (currentDecay > 0) {
        currentDecay = currentDecay - 1;
      } else {
        currentDecay = 0;
      }

      if (shiftDelay == 0) {
        shiftDelay = 0;
        shiftArray(bitRead(timeLine, 0));
      } else {
        shiftDelay++;
      }

    }

    boolean isOn(boolean incomingSustain) {
      shouldSustain = incomingSustain;

      if (!shouldSustain) { sustain = false; }
      if (sustain && !isChannelOn) {
        return true;
      } else {
        return bitRead(timeLine, (sizeof(timeLine) - 1));
      }
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
