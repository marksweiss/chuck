class MidiPlayer {
  MidiIn midiIn;
  MidiOut midiOut;
  int portIn;
  int portOut;

  fun void init(int pIn, int pOut) {
    pIn => portIn;
    pOut => portOut;
    _connectIn();
    _connectOut();
  }

  fun void readIn() {
    while (true) {
      // Use the MIDI Event from MidiIn
      MidiMsg msg;
      midiIn => now;
      while(midiIn.recv(msg)) {
        <<<msg.data1,msg.data2,msg.data3>>>;
      }
    }
  }

  fun void play() {
    while (true) {
      // Use the MIDI Event from MidiIn
      MidiMsg msg;
      midiIn => now;
      while(midiIn.recv(msg)) {
        midiOut.send(msg);
        <<<msg.data1,msg.data2,msg.data3>>>;
      }
    }
  }

  fun void _connectIn() {
    if (!midiIn.open(portIn)) {
      <<< "get_midi_in FAILED for args [" >>>;
      <<< portIn >>>;
      <<< "]" >>>;
      me.exit();
    }
    <<< midiIn >>>;
  }

  fun void _connectOut() {
    if (!midiOut.open(portOut)) {
      <<< "get_midi_out FAILED for args [" >>>;
      <<< portOut >>>;
      <<< "]" >>>;
      me.exit();
    }
    <<< midiOut >>>;
  }

}

fun void main() {
  // TODO CLI ARG
  0 => int MIDI_PORT;

  MidiPlayer midiPlayer;
  midiPlayer.init(MIDI_PORT, MIDI_PORT);
  /* midiPlayer.readIn(); */
  midiPlayer.play();
}

main();
