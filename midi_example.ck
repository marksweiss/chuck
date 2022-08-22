/**
* Class that encapsulates connecting to a MIDI input device on a MIDI channel,
* and connecting to a MIDI output device on a MIDI channel, and then communicating
* with the devices.
*
* To hear output:
* - run `chuck --probe` and identify the ouptut port of the 'IAC Driver Bus 1' device
* - select that device as input device in a software synth
* - run the application
*/

class MidiPlayer {
  0x90 => int NOTE_ON;
  0x80 => int NOTE_OFF;
  0 => int STATUS;
  0 => int CHANNEL; // MIDI Channel 1-15
  1 => int NOTE; // pitch 0-127
  2 => int VELOCITY; // volume / amplitude 0-127

  MidiIn midiIn;
  MidiOut midiOut;
  int portIn;
  int portOut;
  int channelIn;
  int channelOut;  

  fun void init(int pIn, int pOut, int chIn, int chOut) {
    pIn => portIn;
    pOut => portOut;
    chIn => channelIn;
    chOut => channelOut;
    _connectIn();
    _connectOut();
  }

  /**
  * Loops forever receiving MIDIMsgs from the input device and logging them. Useful
  * for debugging mostly.
  */
  fun void readIn() {
    while (true) {
      // Use the MIDI Event from MidiIn
      MidiMsg msg;
      midiIn => now;
      while(midiIn.recv(msg)) {
        <<< msg.data1, msg.data2, msg.data3 >>>;
      }
    }
  }

  /**
  * Loops forever receiving MIDIMsgs from the input device and sending
  * them unaltered to the output device. Equivalent to a MIDI Thru. 
  */
  fun void play() {
    while (true) {
      // Use the MIDI Event from MidiIn
      MidiMsg msg;
      midiIn => now;
      while(midiIn.recv(msg)) {
        midiOut.send(msg);
        <<< msg.data1, msg.data2, msg.data3, "play()">>>;
      }
    }
  }

  /**
  * Takes parameters of a MIDI NoteOn Event, constructs a MidiMsg and sends it
  * to the MIDI output device. Event will sound for as long as the value of duration.
  * 
  */
  fun void play(int note, int velocity, float duration) {
    MidiMsg msg;
    NOTE_ON + channelOut => msg. data1;
    note => msg.data2;
    velocity => msg.data3;
    midiOut.send(msg);
    <<< msg.data1, msg.data2, msg.data3, duration, "play NOTE_ON + channel, note, velocity, duration msecs" >>>;

    duration::ms => now;
  }

  fun void _connectIn() {
    if (!midiIn.open(portIn)) {
      <<< "Connect MidiIn FAILED for args [", portIn, "]" >>>;
      me.exit();
    }
    <<< midiIn >>>;
  }

  fun void _connectOut() {
    if (!midiOut.open(portOut)) {
      <<< "Connect MidiOut FAILED for args [", portOut, "]" >>>;
      me.exit();
    }
    <<< midiOut >>>;
  }

}

fun void main() {
  // TODO CLI ARG
  1 => int MIDI_PORT;
  1 => int CHANNEL_IN;
  2 => int CHANNEL_OUT;

  MidiPlayer midiPlayer;
  midiPlayer.init(MIDI_PORT, MIDI_PORT, CHANNEL_IN, CHANNEL_OUT);
  /* midiPlayer.readIn(); */
  // midiPlayer.play();
  midiPlayer.play(60, 100, 1000);  // noteOn
  midiPlayer.play(60, 0, 10);  // noteOff, velocity 0
}

main();
