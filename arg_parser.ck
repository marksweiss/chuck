class ArgParser {

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
}
