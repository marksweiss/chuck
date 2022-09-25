// Machine.add("lib/arg_parser/arg_parser.ck")
// Machine.add("lib/comp/note.ck")
// Machine.add("lib/comp/chord.ck")
// Machine.add("lib/comp/time.ck")

/**
 * Base interface for an Instrument, which wraps a UGen. Concrete classes add one more more UGen
 * members, implement configure to take the arguments to initialize the state of their Ugen(s),
 * and define a no-arg play, which would typically loop forever and send pitch and gain values
 * to the UGen from chords, as well as advance the global clock using Note duration values.
 */
public class InstrumentBase {
  // ugen constants
  -1 => static int OP_PASSTHRU;
  0 => static int OP_STOP;
  1 => static int OP_SUM;
  2 => static int OP_SUBTRACT;
  3 => static int OP_MULTIPLY;
  4 => static int OP_DIVIDE;

  // TODO MOVE TO PLAYER/SEQUENCE
  128 => static int DEFAULT_NUM_CHORDS;
  Chord chords[DEFAULT_NUM_CHORDS];
  int numChords;
  int maxNumChords;

  0 => numChords;
  DEFAULT_NUM_CHORDS => maxNumChords;

  fun void addChords(Chord newChords[]) {
    if (numChords + newChords.size() >= maxNumChords) {
      <<< "ERROR: Cannot add more chords than", maxNumChords >>>;
      me.exit();
    }
    for (0 => int i; i < newChords.size(); i++) {
      newChords[i] @=> chords[numChords];
      numChords++;
    }
  }
  // /TODO MOVE TO PLAYER/SEQUENCE

  // Override
  fun void play() {}

  // Override
  // Instruemnts generally chain multiple ugens together; they should implement this to set
  // op on the "primary" ugen, such as the SinOsc ugen in a SinOsc wrapper instrument with effects etc.
  fun void setOp() {}

  // Override - each instrument should at a minimum call the built-in help on its UGen.
  // Better implementations provide pruned and specific information about arguments taken to
  // configure and the behavior of the instrument.
  fun void instrHelp() {}

  // Helper used to print standard formatted instrument help lines for each arg
  fun void printInstrHelpForArg(string argName, string description, string type,
                                string domainOfValues) {
    <<< argName, "-", type, "-", description, "-", domainOfValues >>>;
  } 
}
