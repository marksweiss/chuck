// Machine.add("lib/arg_parser/arg_parser.ck")
// Machine.add("lib/comp/note.ck")
// Machine.add("lib/comp/chord.ck")

/**
 * Base interface for an Instrument, which wraps a UGen. Concrete classes add one more more UGen
 * members, implement configure to take the arguments to initialize the state of their Ugen(s),
 * and define a no-arg play, which would typically loop forever and send pitch and gain values
 * to the UGen from chords, as well as advance the global clock using Note duration values.
 */
public class Instrument {
  128 => static int DEFAULT_NUM_CHORDS;
  Chord chords[DEFAULT_NUM_CHORDS];
  int numChords;
  int maxNumChords;
  3 => static int DEFAULT_NUM_PLAYERS;
  DEFAULT_NUM_PLAYERS => int numPlayers;

  fun init() {
    0 => numChords;
    DEFAULT_NUM_CHORDS => maxNumChords;
  }

  fun void addChords(Chord newChords[]) {
    if (numChords + newChords.cap() >= ) {
      <<< "ERROR: Cannot add more chords than", maxNumChords >>>;
      me.exit();
    }
    for (0 => int i; i < newChords.cap(); i++) {
      newChords[i] @=> chords[numChords];
      numChords++;
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
