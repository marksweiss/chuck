// Machine.add("test/assert.ck"); 

/**
 * Class intended to be used to record global state between shreds. Any shred
 * can write to the shared state and any can read it, at any time. State is mapped
 * to shred.id(). In practice, this amounts to maps keyed by int (shred id()) with
 * a mapped value, one for each type we care about, with a simple key/value API.
 */
public class Conductor {
  128 => int MAX_NUM_KEYS;
  int toBool[1];
  0 => int numBoolKeys;
  string boolKeys[MAX_NUM_KEYS]; 
 
  fun void mapToBool(string key) {
    // TEMP DEBUG
    <<< "mapToBool key", key >>>;

    if (toBool.find(key) == 0) {
      false => this.toBool[key]; 
      key => boolKeys[numBoolKeys];
      numBoolKeys++;
    } 
    
    // TEMP DEBUG
    <<< "mapToBool key/val added key", key, "value", boolKeys[key] >>>;
  }

  fun void setBool(string key, int val) {
    val => this.toBool[key]; 
  }

  fun int getBool(string key) {
    // TEMP DEBUG`
    <<< "getBool key", key, "val", toBool[key] >>>;

    return this.toBool[key];
  }

  // TODO MOVE THIS TO DERIVED CLASS WITH SPECIFIC LOGIC FOR IN C
  // Override
  fun void nextStateBool() {
    for (0 => int i; i < this.numBoolKeys; i++) {
      // initial policy is just randomly set each shred's next state to true/false
      if (Math.random2(0, 100) > 50) {
        // TEMP DEBUG`
        <<< "nextStateBool true for", boolKeys[i] >>>;

        true => this.toBool[this.boolKeys[i]];
      } else {
        // TEMP DEBUG`
        <<< "nextStateBool false for", boolKeys[i] >>>;

        false => this.toBool[this.boolKeys[i]];
      }
    }
  }
}

