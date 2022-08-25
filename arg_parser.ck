Machine.add("arg_parser_imports.ck");

class ArgParser {
  // TODO
  // associative array of CliArgBase
  // method to add arg of type CliArgBase
  // contruct and add a concreate-type Arg for each input arg
  // each arg is added to associate array, keyed by flag name
  // for each arg in me.args(), 
  //  - get the arg name
  //  - get the CliArgBase with the matching name from the associated array
  //  - set its val member value
  //  - call getVal() to get val converted to its actual type
  // Now we have an object with associative array of wrapper objects for args of any type, with
  //  value always retrieved by calling getVal() and always keyed to the input arg name


  // TODO THIS ONLY HANDLES INT ARGS, NEED A TYPE/CAST MAP
  /* Expected Args: */
  /* --controller-port-in external controller MIDI input port */
  /* --controller-port-out external controller MIDI output port */
  /* --internal-port-out MIDI input port to which class-generated MidiMsg Events send output */
  /* --channel-in MIDI input channel */
  /* --channel-out MIDI output channel */
  /* CliArgBase args[1];  // size doesn't matter because using as associative array */
  5 => int NUM_ARG_ENTRIES;  // total number of arg names and values in command-line
  CliIntArg contollerPortIn;
  contollerPortIn.init("contollerPortIn");
  contollerPortIn => args["--controller-port-in"];  // one entry for each argument
  /* 0 => args["--controller-port-out"]; */
  /* 0 => args["--internal-port-in"]; */
  /* 0 => args["--channel-in"]; */
  /* 0 => args["--channel-out"]; */
  // read args into array
  /* for (int i; i < NUM_ARG_ENTRIES; ++i) { */
  /*   if (i % 2 == 0) { */
  /*     if (me.arg(i).substring(0, 2) != "--") { */
  /*       <<< "Invalid arg, expecting arg name with leading '--' but got: ", me.arg(i) >>>; */
  /*     } */
  /*     <<< "arg name: ", me.arg(i) >>>; */
  /*   } else { */
  /*     <<< "arg value: ", me.arg(i) >>>; */
  /*     Std.atoi(me.arg(i)) => int argVal; */
  /*     argVal => args[me.arg(i - 1)]; */
  /*   } */ 
  /* } */
}
