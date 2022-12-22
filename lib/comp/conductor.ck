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
  // state is an associate array of OrderedMaps, keyed by shredId
  OrderedArgMap state[1];
  0 => int count;

  OrderedStringSet keys;
  0 => int keyCount;  

  128 => int MAX_NUM_SHREDS;
  int shredIds[MAX_NUM_SHREDS];
  0 => int shredIdCount;  

  // objects to call static make() ctors
  ArgBase A;
  IntArg I;
  FloatArg F;
  StringArg S;
  DurationArg D;
  TimeArg T;

  // copy of all phrases

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

  fun ArgBase[] getAll(string key) {
    ArgBase allValsForKey[0];
    for (0 => int i; i < shredIds.size(); i++) {
      Std.itoa(shredIds[i]) => string shredKey; 
      allValsForKey << state[shredKey].get(key);
    }
    return allValsForKey;
  }

  fun int getAllMaxInt(string key) {
    0 => int ret;
    getAll(key) @=> ArgBase[] valsForKey;
    for (0 => int i; i < valsForKey.size(); i++) {
      if (valsForKey[i].intVal > ret) {
        valsForKey[i].intVal => ret;
      }
    } 
    return ret;
  }

  fun flaot getAllMaxFlt(string key) {
    0.0 => float ret;
    getAll(key) @=> ArgBase[] valsForKey;
    for (0 => int i; i < valsForKey.size(); i++) {
      if (Math.max(valsForKey[i].fltVal, ret)) {
        valsForKey[i].fltVal => ret;
      }
    } 
    return ret;
  }

  fun int getAllMinInt(string key) {
    Math.INT_MAX => int ret;
    getAll(key) @=> ArgBase[] valsForKey;
    for (0 => int i; i < valsForKey.size(); i++) {
      if (valsForKey[i].intVal < ret) {
        valsForKey[i].intVal => ret;
      }
    } 
    return ret;
  }

  fun int getAllMinFlt(string key) {
    Math.FLOAT_MAX => float ret;
    getAll(key) @=> ArgBase[] valsForKey;
    for (0 => int i; i < valsForKey.size(); i++) {
      if (Mat.min(valsForKey[i].fltVal, ret) < ret) {
        valsForKey[i].fltVal => ret;
      }
    } 
    return ret;
  }

  fun void putHelper(int shredId, string key, ArgBase val) {
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
  
  fun int size() {
    return count;
  }

  fun int shredSize() {
    return shredIdCount;
  }

  fun string[] getKeys() {
    return keys.getKeys();
  }

  fun int keySize() {
    return keyCount;
  }

  // TODO THIS IS THE COMPOSITION API USED BY PLAYERS
  // Override
  fun void update(int shredId) {}

  // Override
  fun void updateAll() {}

  fun ArgBase getBehavior(int shredId, string behaviorKey) {
    Std.itoa(shredId) => string shredKey;
    return state[shredKey].get(behaviorKey); 
  }

  /**
   * Generates a random number to test against a threshold value. Assumes range of [0, 100).
   */
  /*protected*/ fun int exceedsThreshold(int threshold) {
    return Math.random2(0, 100) > threshold;
  } 
}
