/**
 * Base interface for an Instrument, which wraps a UGen. Concrete classes add one more more UGen
 * members, implement configure to take the arguments to initialize the state of their Ugen(s),
 * and define a no-arg play, which would typically loop forever and send pitch and gain values
 * to the UGen from chords, as well as advance the global clock using Note duration values.
 */
public class InstrumentBase {
  // UGen constants
  -1 => static int OP_PASSTHRU;
  0 => static int OP_STOP;
  1 => static int OP_SUM;
  2 => static int OP_SUBTRACT;
  3 => static int OP_MULTIPLY;
  4 => static int OP_DIVIDE;

  128 => static int MAX_NUM_GENS;
  0 => int genCount;

  128 => static int MAX_NUM_ATTRS;
  string attrNames[MAX_NUM_ATTRS];
  0 => int attrCount;

  // Override
  fun void play() {}

  // Override
  // get a reference to the global env member
  fun ADSR getEnv() {}

  // Override
  // get a reference to a global gain member
  fun Gain getGain() {}

  // Override
  // get a reference to a gen gain member
  fun Gain getGain(int genIdx) {}

  // Override
  // set gain for one gen
  fun void setGain(int genIdx, float gainVal) {}

  // Override
  // set gain for all gens
  fun void setGain(float gainVal) {}

  // Override
  // get reference to a gen
  fun UGen getGen(int genIdx) {}

  // Override
  // ger array of references to all gens
  fun UGen[] getGens() {}

  fun int genSize() {
    return genCount;
  }

  fun int attributeSize() {
    return attrCount;
  }

  fun string[] attributeNames() {
    return attrNames;
  }

  // Override
  // set an attribute by name for a single gen 
  fun void setAttr(int genIdx, string attrName, float attrVal) {}
  fun void setAttr(int genIdx, string attrName, int attrVal) {}
  fun void setAttr(int genIdx, string attrName, time attrVal) {}
  fun void setAttr(int genIdx, string attrName, dur attrVal) {}
  fun void setAttr(int genIdx, string attrName, string attrVal) {}

  // Override
  // set an attribute by name for all gens 
  fun void setAttr(string attrName, float attrVal) {}
  fun void setAttr(string attrName, int attrVal) {}
  fun void setAttr(string attrName, time attrVal) {}
  fun void setAttr(string attrName, dur attrVal) {}
  fun void setAttr(string attrName, string attrVal) {}

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
