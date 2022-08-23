/**
* Class that encapsulates connecting to a MIDI input device on a MIDI channel,
* and connecting to a MIDI output device on a MIDI channel, and then communicating
* with the devices.
* 
* Args:
* --controller-port-in external controller MIDI input port
* --controller-port-out external controller MIDI output port
* --internal-port-out MIDI input port to which class-generated MidiMsg Events send output
* --channel-in MIDI input channel
* --channel-out MIDI output channel
*
* Usage:
*  chuck midi_example.ck:--controller-port-in:0:--controller-port-out:1: \
*    --internal-port-out:1:--channel-in:1:--channel-out:2  
*
* To hear output:
* - run `chuck --probe` and identify the ouptut port of the 'IAC Driver Bus 1' device
* - select that device as input device in a software synth
* - run the application
*/

class MidiPlayer {
  0x90 => int NOTE_ON;
  0x80 => int NOTE_OFF;

  string name;
  MidiIn midiIn;
  MidiOut midiOut;
  int portIn;
  int portOut;
  int channelIn;
  int channelOut;  

  fun void init(string argName, int pIn, int pOut, int chIn, int chOut) {
    argName => name;
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
        <<< msg.data1, msg.data2, msg.data3, name >>>;
      }
    }
  }

  /**
  * Loops forever receiving MIDIMsgs from the input device and sending
  * them unaltered to the output device. Events will sound as controlled by the messges
  * receieved. So typically note on and note off messages will be processed from a controller.
  */
  fun void play() {
    while (true) {
      // Use the MIDI Event from MidiIn
      MidiMsg msg;
      midiIn => now;
      while(midiIn.recv(msg)) {
        midiOut.send(msg);
        <<< msg.data1, msg.data2, msg.data3, name, "play()">>>;
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
    <<< msg.data1, msg.data2, msg.data3, duration, name, "play NOTE_ON + channel, note, velocity, duration msecs" >>>;

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
  1 => int DEFAULT_PORT;

  // TODO THIS ONLY HANDLES INT ARGS, NEED A TYPE/CAST MAP
  /* Expected Args: */
  /* --controller-port-in external controller MIDI input port */
  /* --controller-port-out external controller MIDI output port */
  /* --internal-port-out MIDI input port to which class-generated MidiMsg Events send output */
  /* --channel-in MIDI input channel */
  /* --channel-out MIDI output channel */
  int args[1];  // size doesn't matter because using as associative array
  10 => int NUM_ARG_ENTRIES;  // total number of arg names and values in command-line
  0 => args["--controller-port-in"];  // one entry for each argument
  0 => args["--controller-port-out"];
  0 => args["--internal-port-in"];
  0 => args["--channel-in"];
  0 => args["--channel-out"];
  // read args into array
  for (int i; i < NUM_ARG_ENTRIES; ++i) {
    if (i % 2 == 0) {
      if (me.arg(i).substring(0, 2) != "--") {
        <<< "Invalid arg, expecting arg name with leading '--' but got: ", me.arg(i) >>>;
      }
      <<< "arg name: ", me.arg(i) >>>;
    } else {
      <<< "arg value: ", me.arg(i) >>>;
      Std.atoi(me.arg(i)) => int argVal;
      argVal => args[me.arg(i - 1)];
    } 
  }

  MidiPlayer controllerPlayer;
  controllerPlayer.init("Controller", args["--controller-port-in"], args["--controller-port-out"],
    args["--channel-in"], args["--channel-out"]);
  MidiPlayer internalPlayer;
  internalPlayer.init("Internal", args["--internal-port-in"], DEFAULT_PORT, args["--channel-in"],
    args["--channel-out"]);

  internalPlayer.play(60, 100, 1000);  // noteOn */
  internalPlayer.play(60, 0, 10);  // noteOff, velocity 0 */
  controllerPlayer.play();
}

main();
