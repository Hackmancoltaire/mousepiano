#define noteLife 5

class Key {
  private:
    boolean isChannelOn = false;
    boolean sustain = false;
    boolean shouldSustain = false;

  public:
    int id;
    int octave = -2;
    String note = "";
  
    Key() { }

    // This should be set so we know what kind of key this is
    void setId(int index) {
      id = index;
      getOctave();
      getNote();
    }

    void channelOn(int channel) {
      isChannelOn = true;
    }

    void channelOff(int channel) {
      isChannelOn = false;
    }

    void allOff() {
      isChannelOn = false;
      sustain = false;
    }

    boolean isOn() {
        return isChannelOn;
    }

    int getOctave() {
      if (octave == -2) { octave = floor(id / 12) - 1; }
      return octave;
    }

    String getNote() {
      if (note == "") {
        if (id == 0 || id % 12 == 0) {
          note = "C";
        } else if (id - 1 == 0 || (id - 1) % 12 == 0) {
          note = "C#";
        } else if (id - 2 == 0 || (id - 2) % 12 == 0) {
          note = "D";
        } else if (id - 3 == 0 || (id - 3) % 12 == 0) {
          note = "D#";
        } else if (id - 4 == 0 || (id - 4) % 12 == 0) {
          note = "E";
        } else if (id - 5 == 0 || (id - 5) % 12 == 0) {
          note = "F";
        } else if (id - 6 == 0 || (id - 6) % 12 == 0) {
          note = "F#";
        } else if (id - 7 == 0 || (id - 7) % 12 == 0) {
          note = "G";
        } else if (id - 8 == 0 || (id - 8) % 12 == 0) {
          note = "G#";
        } else if (id - 9 == 0 || (id - 9) % 12 == 0) {
          note = "A";
        } else if (id - 10 == 0 || (id - 11) % 12 == 0) {
          note = "A#";
        } else if (id - 11 == 0 || (id - 11) % 12 == 0) {
          note = "B";
        }
      }

      return note;
    }

    boolean isSharp() {
      if (note == "") {
        getNote();
      }

      return (note.indexOf("#") > -1);
    }
};
