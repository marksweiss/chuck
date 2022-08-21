fun MidiIn getMidiIn(int port) {
  MidiIn midiIn;
  if (!midiIn.open(port)) {
    <<< "get_midi_in FAILED for args [" >>>;
    <<< port >>>;
    <<< "]" >>>;
    me.exit();
  }
  
  return midiIn; 
}

fun MidiOut getMidiOut(int port) {
  MidiOut midiOut;
  if (!midiOut.open(port)) {
    <<< "get_midi_out FAILED for args [" >>>;
    <<< port >>>;
    <<< "]" >>>;
    me.exit();
  }
  
  return midiOut; 
}

fun void getMidiInput(MidiIn midiIn) {
  while (true) {
    // Use the MIDI Event from MidiIn
    MidiMsg msg;
    midiIn => now;
    while(midiIn.recv(msg)) {
      <<<msg.data1,msg.data2,msg.data3,"MIDI Message">>>;
    }
  }
}

fun void main() {
  // TODO CLI ARG
  0 => int MIDI_CHANNEL;

  getMidiIn(MIDI_CHANNEL) @=>  MidiIn midiIn;
  getMidiOut(MIDI_CHANNEL) @=>  MidiOut midiOut;
  <<< midiIn >>>;
  <<< midiOut >>>;
  getMidiInput(midiIn);
}

main();
