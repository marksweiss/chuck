// Machine.add("test/assert.ck"); 
// Machine.add("lib/arg_parser/arg_base.ck"); 
// Machine.add("lib/arg_parser/float_arg.ck"); 
// Machine.add("lib/arg_parser/int_arg.ck"); 
// Machine.add("lib/arg_parser/string_arg.ck"); 
// Machine.add("lib/collection/map.ck"); 
// Machine.add("lib/collection/set.ck"); 


// TODO TEST
/**
 * Class intended to be used to record global state between shreds. Any shred
 * can write to the shared state and any can read it, at any time. State is mapped
 * to shred.id(), and each shredId key has a map of key/values storing the state for
 * that shred. shredId keys must be int, and state keys must be strings. State values
 * are any of the scalar value types supported by ArgBase.
 */
public class Conductor {
  // state is an associative array of OrderedMaps, keyed by shredId
  OrderedArgMap state[1];
  0 => int count;

  OrderedStringSet keys;
  0 => int keyCount;  

  128 => int MAX_NUM_SHREDS;
  int shredIds[MAX_NUM_SHREDS];
  0 => int shredIdCount;  

  OrderedArgMap globalState;

  // objects to call static make() ctors
  ArgBase A;
  IntArg I;
  FloatArg F;
  StringArg S;
  DurationArg D;
  TimeArg T;

  // Accessors
  fun void put(int shredId, string key, int val) {
    I.make(key, val) @=> IntArg arg;
    putHelper(shredId, key, arg);
  }

  fun void put(int shredId, string key, float val) {
    F.make(key, val) @=> FloatArg arg;
    putHelper(shredId, key, arg);
  }

  fun void put(int shredId, string key, string val) {
    S.make(key, val) @=> StringArg arg;
    putHelper(shredId, key, arg);
  }

  fun void put(int shredId, string key, dur val) {
    D.make(key, val) @=> DurationArg arg;
    putHelper(shredId, key, arg);
  }

  fun void put(int shredId, string key, time val) {
    T.make(key, val) @=> TimeArg arg;
    putHelper(shredId, key, arg);
  }

  fun void putGlobal(string key, int val) {
    I.make(key, val) @=> IntArg arg;
    putHelper(key, arg);
  }

  fun void putGlobal(string key, float val) {
    F.make(key, val) @=> FloatArg arg;
    putHelper(key, arg);
  }

  fun void putGlobal(string key, string val) {
    S.make(key, val) @=> StringArg arg;
    putHelper(key, arg);
  }

  fun void putGlobal(string key, dur val) {
    D.make(key, val) @=> DurationArg arg;
    putHelper(key, arg);
  }

  fun void putGlobal(string key, time val) {
    T.make(key, val) @=> TimeArg arg;
    putHelper(key, arg);
  }

  fun ArgBase get(int shredId, string key) {
    Std.itoa(shredId) => string shredKey;
    if (state.find(shredKey) > 1) {
      <<< "ERROR: ILLEGAL STATE. shredKey should have 0 or 1 entries in Conductor" >>>;
      me.exit();
    }

    if (state.find(shredKey) == 1) {
      return state[shredKey].get(key);
    } else {
      return null;
    }
  }

  fun float getFloat(int shredId, string key) {
    return get(shredId, key).fltVal;
  }

  fun int getInt(int shredId, string key) {
    return get(shredId, key).intVal;
  }

  fun int getBool(int shredId, string key) {
    return get(shredId, key).intVal == true;
  }

  fun ArgBase[] getAll(string key) {
    ArgBase allValsForKey[0];
    for (0 => int i; i < shredIds.size(); i++) {
      Std.itoa(shredIds[i]) => string shredKey; 
      allValsForKey << state[shredKey].get(key);
    }
    return allValsForKey;
  }

  // Aggregates
  fun int getAllMaxInt(string key) {
    0 => int ret;
    getAll(key) @=> ArgBase valsForKey[];
    for (0 => int i; i < valsForKey.size(); i++) {
      if (valsForKey[i].intVal > ret) {
        valsForKey[i].intVal => ret;
      }
    } 
    return ret;
  }

  fun float getAllMaxFlt(string key) {
    0.0 => float ret;
    getAll(key) @=> ArgBase valsForKey[];
    for (0 => int i; i < valsForKey.size(); i++) {
      if (Math.max(valsForKey[i].fltVal, ret)) {
        valsForKey[i].fltVal => ret;
      }
    } 
    return ret;
  }

  fun int getAllMinInt(string key) {
    Math.INT_MAX => int ret;
    getAll(key) @=> ArgBase valsForKey[];
    for (0 => int i; i < valsForKey.size(); i++) {
      if (valsForKey[i].intVal < ret) {
        valsForKey[i].intVal => ret;
      }
    } 
    return ret;
  }

  fun float getAllMinFlt(string key) {
    Math.FLOAT_MAX => float ret;
    getAll(key) @=> ArgBase valsForKey[];
    for (0 => int i; i < valsForKey.size(); i++) {
      if (Math.min(valsForKey[i].fltVal, ret) < ret) {
        valsForKey[i].fltVal => ret;
      }
    } 
    return ret;
  }

  fun ArgBase getGlobal(string key) {
    return globalState.get(key);
  }
 
  fun float getGlobalFloat(string key) {
    return globalState.get(key).fltVal;
  }
 
  fun int getGlobalInt(string key) {
    return globalState.get(key).intVal;
  }
 
  fun int getGlobalBool(string key) {
    return globalState.get(key).intVal == true;
  }
 
  // Metadata, counts and keys 
  fun int size() {
    return count;
  }

  fun int globalSize() {
    return globalState.size();
  }

  fun int shredSize() {
    return shredIdCount;
  }

  fun string[] getKeys() {
    return keys.getKeys();
  }

  fun string[] getGlobalKeys() {
    return globalState.getKeys();
  }

  fun int keySize() {
    return keyCount;
  }

  fun int globalKeySize() {
    return globalState.size();
  }

  fun int hasKey(int shredId, string key) {
    Std.itoa(shredId) => string shredKey;
    return state[shredKey].hasKey(key);
  }

  fun int hasGlobalKey(string key) {
    return globalState.hasKey(key);
  }

  // Public API
  // Override
  /**
   * Intended to be called during performance, by Players, to update state associated with this player
   */
  fun /*protected*/ void update(int shredId) {}

  // Override
  /**
   * Intended to be called during performance, by Players, to update state associated with every player 
   */
  fun /*protected*/ void updateAll() {}

  // Override
  /**
   * Intended to be called by the control loop, to end the performance when all Players have stopped playing
   */
  fun /*protected*/ int isPlaying() {}

  // TODO DO WE NEED THIS?
  fun ArgBase getBehavior(int shredId, string behaviorKey) {
    Std.itoa(shredId) => string shredKey;
    return state[shredKey].get(behaviorKey); 
  }

  /**
   * Generates a random number to test against a threshold value. Assumes range of [0, 100). Used to generate
   * performance behavior that is dynamic over time against tunable parameters.
   */
  fun /*protected*/ int exceedsThreshold(int threshold) {
    return Math.random2(0, 100) > threshold;
  } 

  // Private Helpers

  fun /*private*/ void putHelper(int shredId, string key, ArgBase val) {
    Std.itoa(shredId) => string shredKey;
    if (state.find(shredKey) > 1) {
      <<< "ERROR: ILLEGAL STATE. shredKey should have 0 or 1 entries in Conductor" >>>;
      me.exit();
    }

    if (state.find(shredKey) == 0) {
      OrderedArgMap shredStateMap;
      shredStateMap @=> state[shredKey];
      count++;
      shredId @=> shredIds[shredIdCount++];
    }
    state[shredKey] @=> OrderedArgMap shredStateMap;

    if (!keys.hasKey(key)) {
      keys.put(key); 
    }

    shredStateMap.put(key, val);
  }
  
  fun void /*private*/ putHelper(string key, ArgBase val) {
    globalState.put(key, val);
  }
}
