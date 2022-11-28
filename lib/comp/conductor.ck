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

  fun void putHelper(int shredId, string key, ArgBase val) {

    // TEMP DEBUG
    /* <<< "IN CONDUCTOR PUTHELPER key", key, "shred", me.id() >>>; */

    // TEMP DEBUG
    /* <<< "TOP OF SHRED STATE MAP putHelper()" >>>; */

    Std.itoa(shredId) => string shredKey;

    // TEMP DEBUG
    /* <<< "SHRED STATE MAP shredKey", shredKey >>>; */

    if (state.find(shredKey) > 1) {
      <<< "ERROR: ILLEGAL STATE. shredKey should have 0 or 1 entries in Conductor" >>>;
      me.exit();
    }

    // TEMP DEBUG
    /* <<< "SHRED STATE MAP after find()" >>>; */

    if (state.find(shredKey) == 0) {
      OrderedArgMap shredStateMap;
      shredStateMap @=> state[shredKey];
      count++;
      shredId @=> shredIds[shredIdCount++];
    }
    state[shredKey] @=> OrderedArgMap shredStateMap;

    // TEMP DEBUG
    /* <<< "SHRED STATE MAP after new thread check, shredStateMap", shredStateMap >>>; */

    // TEMP DEBUG
    /* <<< "SHRED STATE MAP BEFORE key assignment, keys.size()", keys.size(), "keyCount", keyCount, "key", key, "keys[0]", keys[0], "keys.find(key)", keys.find(key) >>>; */

    if (!keys.hasKey(key)) {
      keys.put(key); 
    }

    // TEMP DEBUG
    /* <<< "SHRED STATE MAP after new thread check, key=keys[keyCount - 1]", keys[keyCount - 1], "val", val >>>; */

    // TEMP DEBUG
    /* <<< "BOTTOM OF SHRED STATE MAP putHelper()" >>>; */

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
    /* string retKeys[keyCount]; */
    /* for (0 => int i; i < keyCount; i++) { */
    /*   keys[i] => retKeys[i]; */
    /* } */
    /* return retKeys; */
  }

  fun int keySize() {
    return keyCount;
  }

  // TODO THIS IS THE COMPOSITION API USED BY PLAYERS
  // Override
  fun void update(int shredId) {}

  // Override
  fun void updateAll() {}

  // Override
  fun int getIntBehavior(int shredId, string behaviorKey) {} 
  fun int getBoolBehavior(int shredId, string behaviorKey) {} 
  fun float getFloatBehavior(int shredId, string behaviorKey) {} 
  fun string getStringBehavior(int shredId, string behaviorKey) {} 
  fun dur getDurationBehavior(int shredId, string behaviorKey) {} 
  fun time getTimeBehavior(int shredId, string behaviorKey) {} 

  /**
   * Generates a random number to test against a threshold value. Assumes range of [0, 100).
   */
  /*private*/ fun int exceedsThreshold(int threshold) {
    return Math.random2(0, 100) > threshold;
  } 
}
