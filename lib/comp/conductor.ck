// Machine.add("test/assert.ck"); 
// Machine.add("lib/arg_parser/arg_base.ck"); 
// Machine.add("lib/arg_parser/float_arg.ck"); 
// Machine.add("lib/arg_parser/int_arg.ck"); 
// Machine.add("lib/arg_parser/string_arg.ck"); 
// Machine.add("lib/collection/map.ck"); 


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

  128 => int MAX_NUM_KEYS;
  string keys[MAX_NUM_KEYS];
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
      state[shredKey].get(key);
    } else {
      return A.makeEmpty();
    }
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

    if (!keys.find(key)) {
      key @=> keys[keyCount++]; 
    }
    shredStateMap.put(key, val);
  }
  
  fun int size() {
    return count;
  }

  fun string[] getKeys() {
    return keys;
  }

  fun int keySize() {
    return keyCount;
  }

  // Override
  fun void update(int shredId) {}

  // TODO THIS IS THE ACTUAL API
  // Override
  fun void updateAll() {}
}
