// Depends on: Machine.add("arg_parser_imports.ck");

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
* - run `chuck --probe` and identify desired input and output devices / ports
*  - e.g. - 'IAC Driver Bus 1' is an internal device
*  - e.g. - controllers that are plugged in will show up as their own devices
* - set up arguments
* - run the application
* - cli: $> chuck lib/arg_parser/arg_base.ck lib/arg_parser/int_arg.ck \
*           lib/arg_parser/float_arg.ck lib/arg_parser/string_arg.ck \
*           lib/arg_parser/arg_parser.ck lib/midi/midi_player.ck
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

  ArgParser argParser;
  argParser.addIntArg("controllerPortIn", 0) @=> IntArg controllerPortIn;
  argParser.addIntArg("controllerPortOut", 0) @=> IntArg controllerPortOut;
  argParser.addIntArg("internalPortOut", 0) @=> IntArg internalPortOut;
  argParser.addIntArg("channelIn", 0) @=> IntArg channelIn;
  argParser.addIntArg("channelOut", 0) @=> IntArg channelOut;
  argParser.loadArgs();

  MidiPlayer controllerPlayer;
  controllerPlayer.init(
    "Controller",
    argParser.args[controllerPortIn.toFlag()].intVal,
    argParser.args[controllerPortOut.toFlag()].intVal,
    argParser.args[channelIn.toFlag()].intVal,
    argParser.args[channelOut.toFlag()].intVal
  );
  MidiPlayer internalPlayer;
  internalPlayer.init(
    "Internal",
    argParser.args[internalPortOut.toFlag()].intVal,
    DEFAULT_PORT,
    argParser.args[channelIn.toFlag()].intVal,
    argParser.args[channelOut.toFlag()].intVal
  );

  /* internalPlayer.play(60, 100, 1000);  // noteOn *1/ */
  /* internalPlayer.play(60, 0, 10);  // noteOff, velocity 0 *1/ */
  /* controllerPlayer.play(); */
}

main();
