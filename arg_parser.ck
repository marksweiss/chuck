// depends on arg_parser_imports.ck

class ArgParser {
  int numArgs;
  CliArgBase args[1];  // size doesn't matter because using as associative array */
  int types[1];

  fun void addIntArg(string name, int val) {
    CliIntArg.make(name, val) @=> CliIntArg arg;
    arg.nameToFlag() => string flag;
    /* <<< flag, val, arg.intVal >>>; */
    arg @=> args[flag];
    arg.type @=> types[flag];
    /* <<< flag, args[flag].name, args[flag].intVal, args[flag] >>>; */
    numArgs++;
  }
  fun void addFloatArg(string name, float val) {
    CliFloatArg.make(name, val) @=> CliFloatArg arg;
    arg.nameToFlag() => string flag;
    arg @=> args[flag];
    arg.type @=> types[flag];
    numArgs++;
  }

  fun void addStringArg(string name, string val) {
    CliStringArg.make(name, val) @=> CliStringArg arg;
    arg.nameToFlag() => string flag;
    arg @=> args[flag];
    arg.type @=> types[flag];
    numArgs++;
  }

  fun void loadArgs() {
    /* <<< args, me.args() >>>; */
    for (int i; i < me.args(); i++) {
      /* <<< me.arg(i) >>>; */
      if (i % 2 == 0) {
        if (me.arg(i).substring(0, 2) != "--") {
          <<< "Invalid arg, expecting arg name with leading '--' but got: ", me.arg(i) >>>;
        }
        /* <<< "arg name: ", me.arg(i) >>>; */
      } else {
        /* <<< "arg value: ", me.arg(i) >>>; */
        me.arg(i - 1) => string flag;
        if (types[flag] == CliIntArg.type) {
          /* <<< me.arg(i), flag >>>; */
          Std.atoi(me.arg(i)) @=> args[flag].intVal;
          /* <<< me.arg(i), flag, args[flag].intVal >>>; */
        } else if (types[flag] == CliFloatArg.type) {
          Std.atof(me.arg(i)) @=> args[flag].fltVal;
        } else if (types[flag] == CliStringArg.type) {
          me.arg(i) @=> args[flag].strVal;
        }
      } 
    }
  }
}

/* Expected Args: */
/* --controller-port-in external controller MIDI input port */
/* --controller-port-out external controller MIDI output port */
/* --internal-port-out MIDI input port to which class-generated MidiMsg Events send output */
/* --channel-in MIDI input channel */
/* --channel-out MIDI output channel */
ArgParser argParser;
argParser.addIntArg("controllerPortIn", 0);
argParser.addIntArg("controllerPortOut", 0);
argParser.addIntArg("internalPortOut", 0);
argParser.addIntArg("channelIn", 0);
argParser.addIntArg("channelOut", 0);
argParser.loadArgs();

<<< "numArgs: ", argParser.numArgs, "args: ", argParser.args, "types: ", argParser.types >>>;
