class MidiPlayer {
  int portIn;
  int portOut;
  int channelIn;
  int channelOut;
  MidiIn midiIn;
  MidiOut midiOut;
  
  fun void init(int pIn, int pOut, int ci, int co) {
    pIn => portIn;
    pOut => portOut;
    ci => channelIn;
    co => channelOut; 

    MidiIn midiIn;
    if (!midiIn.open(portIn)) {
      <<<"get_midi_in FAILED for args [" >>>;
      <<<portIn>>>;
      <<<"]">>>;
      me.exit();
    }
    <<< midiIn >>>;

    MidiOut midiOut;
    if (!midiOut.open(portOut)) {
      <<<"get_midi_out FAILED for args [">>>;
      <<<portOut>>>;
      <<<"]">>>;
      me.exit();
    }
    <<< midiIn >>>;
  }
 
  /* fun MidiIn getMidiIn(int port) { */
  /*   MidiIn midiIn; */
  /*   if (!midiIn.open(port)) { */
  /*     <<<"get_midi_in FAILED for args [" >>>; */
  /*     <<<port>>>; */
  /*     <<<"]">>>; */
  /*     me.exit(); */
  /*   } */
    
  /*   return midiIn; */ 
  /* } */

  /* fun MidiOut getMidiOut(int port) { */
  /*   MidiOut midiOut; */
  /*   if (!midiOut.open(port)) { */
  /*     <<<"get_midi_out FAILED for args [">>>; */
  /*     <<<port>>>; */
  /*     <<<"]">>>; */
  /*     me.exit(); */
  /*   } */
    
  /*   return midiOut; */ 
  /* } */

  fun void readInput() {
    while (true) {
      // Use the MIDI Event from MidiIn
      MidiMsg msg;
      midiIn => now;
      while(midiIn.recv(msg)) {
        <<<msg.data1,msg.data2,msg.data3,"MIDI Message">>>;
      }
    }
  }

  fun void play() {
    while (true) {
      // Use the MIDI Event from MidiIn
      MidiMsg msg;
      midiIn => now;
      while(midiIn.recv(msg)) {
        <<<msg.data1,msg.data2,msg.data3,"MIDI Message">>>;
        midiOut.send(msg);
      }
    }
  }
}

fun void main() {
  // TODO CLI ARG
  0 => int MIDI_PORT;
  1 => int MIDI_IN_CHANNEL;
  1 => int MIDI_OUT_CHANNEL;

  /* getMidiIn(MIDI_CHANNEL) @=>  MidiIn midiIn; */
  /* getMidiOut(MIDI_CHANNEL) @=>  MidiOut midiOut; */
  /* <<< midiIn >>>; */
  /* <<< midiOut >>>; */
  /* // getMidiInput(midiIn); */
  /* processMidiInputToOutput(midiIn, midiOut); */

  MidiPlayer midiPlayer;
  midiPlayer.init(MIDI_PORT, MIDI_PORT, MIDI_IN_CHANNEL, MIDI_OUT_CHANNEL);
  /* midiPlayer.play(); */
  midiPlayer.readInput();
}

main();
