class MidiPlayer {
  MidiIn midiIn;
  MidiOut midiOut;
  int portIn;
  int portOut;

  fun void init(int pIn, int pOut) {
    _connectIn(pIn);
    _connectOut(pOut);
  }

  fun void readIn() {
    while (true) {
      // Use the MIDI Event from MidiIn
      MidiMsg msg;
      midiIn => now;
      while(midiIn.recv(msg)) {
        <<<msg.data1,msg.data2,msg.data3,"MIDI Message">>>;
      }
    }
  }

  fun void _connectIn(int port) {
    if (!midiIn.open(port)) {
      <<< "get_midi_in FAILED for args [" >>>;
      <<< port >>>;
      <<< "]" >>>;
      me.exit();
    }
    <<< midiIn >>>;
  }

  fun void _connectOut(int port) {
    if (!midiOut.open(port)) {
      <<< "get_midi_out FAILED for args [" >>>;
      <<< port >>>;
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
  midiPlayer.readIn();
}

main();
