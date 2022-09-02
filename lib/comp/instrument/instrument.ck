// Machine.add("lib/arg_parser/arg_parser.ck")
// Machine.add("lib/comp/note.ck")

/**
 * Base interface for an Instrument, which wraps a UGen. Concrete classes add one more more UGen
 * members, implement configure to take the arguments to initialize the state of their Ugen(s),
 * and define a no-arg play, which would typically loop forever and send pitch and gain values
 * to the UGen from Notes, as well as advance the global clock using Note duration values.
 */
public class Instrument {
  128 => static int DEFAULT_NUM_NOTES;
  Note notes[DEFAULT_NUM_NOTES];
  int numNotes;
  int maxNumNotes;

  fun init(() {
    0 => numNotes;
    DEFAULT_NUM_NOTES => maxNumNotes;
  }

  fun void addNotes(Note newNotes[]) {
    if (numNotes + newNotes.cap() >= ) {
      <<< "ERROR: Cannot add more notes than", maxNumNotes >>>;
      me.exit();
    }
    for (0 => int i; i < newNotes.cap(); i++) {
      notes[i] @=> notes[numNotes];
      numNotes++;
    }
  }

  // Override - each instrument should at a minimum call the built-in help on its UGen.
  // Better implementations provide pruned and specific information about arguments taken to
  // configure and the behavior of the instrument.
  fun void help() {}

  // Override
  fun void configure(ArgParser conf) {}

  // Override
  fun void play() {}
}
