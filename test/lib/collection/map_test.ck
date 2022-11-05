// cli: chuck test/assert.ck lib/arg_parser/arg_base.ck lib/arg_parser/int_arg.ck \
//            lib/collection/arg_map.ck lib/collection/object_map.ck test/lib/collection/map_test.ck

"Test Map" => string TEST_SUITE;

fun void testOrderedArgMapPutGetSize() {
  // setup
  "testOrderedArgMapPutGet" => string testName;
  "put() adds argument key and ArgBase value to the map" => string msg;

  "key" => string key;
  "arg" => string argName; 
  100 => int argVal;
  IntArg I;
  I.make(argName, argVal) @=> IntArg arg;

  // call
  OrderedArgMap m;
  m.put(key, arg);
  m.get(key) @=> ArgBase actualArg;

  // assert
  Assert.assert(m.size(), 1, testName, msg);
  I.make(argName, argVal) @=> IntArg expectedArg;
  Assert.assert(expectedArg.name, actualArg.name, testName, msg);
  Assert.assert(expectedArg.intVal, actualArg.intVal, testName, msg);
}

// nearly identical to testOrderedArgMapPutGet() but this type stores values as Object
fun void testOrderedObjectMapPutGetSize() {
  // setup
  "testOrderedObjectMapPutGet" => string testName;
  "put() adds argument key and Object value to the map" => string msg;

  "key" => string key;
  "arg" => string argName; 
  100 => int argVal;
  IntArg I;
  I.make(argName, argVal) @=> IntArg arg;

  // call
  OrderedObjectMap m;
  m.put(key, arg);
  m.get(key) $ ArgBase @=> ArgBase actualArg;

  // assert
  Assert.assert(m.size(), 1, testName, msg);
  I.make(argName, argVal) @=> IntArg expectedArg;
  Assert.assert(expectedArg.name, actualArg.name, testName, msg);
  Assert.assert(expectedArg.intVal, actualArg.intVal, testName, msg);
}

fun void testOrderedArgMapHasKey() {
  // setup
  "testOrderedArgMapHasKey" => string testName;
  "hasKey() returns true if key is present, false if it is not" => string msg;

  "key" => string key;
  "arg" => string argName; 
  100 => int argVal;
  IntArg I;
  I.make(argName, argVal) @=> IntArg arg;

  OrderedArgMap m;
  m.put(key, arg);

  // call
  m.hasKey(key) => int hasKey;
  m.hasKey("thisKeyNotAdded") => int hasAnotherKey;

  // assert
  Assert.assert(true, hasKey, testName, msg);
  Assert.assert(false, hasAnotherKey, testName, msg);
}

fun void testOrderedObjectMapHasKey() {
  // setup
  "testOrderedObjectMapHasKey" => string testName;
  "hasKey() returns true if key is present, false if it is not" => string msg;

  "key" => string key;
  "arg" => string argName; 
  100 => int argVal;
  IntArg I;
  I.make(argName, argVal) @=> IntArg arg;

  OrderedObjectMap m;
  m.put(key, arg);

  // call
  m.hasKey(key) => int actual;
  m.hasKey("thisKeyNotAdded") => int hasAnotherKey;

  // assert
  Assert.assert(true, actual, testName, msg);
  Assert.assert(false, hasAnotherKey, testName, msg);
}

fun void testOrderedArgMapDelete() {
  // setup
  "testOrderedArgMapDelete" => string testName;
  "delete() removes key from map" => string msg;

  "key" => string key;
  "arg" => string argName; 
  100 => int argVal;
  IntArg I;
  I.make(argName, argVal) @=> IntArg arg;

  OrderedArgMap m;
  m.put(key, arg);
  m.hasKey(key) => int hasKeyBeforeDelete;

  // call
  m.delete(key);
  m.hasKey(key) => int hasKeyAfterDelete;

  // assert
  Assert.assert(true, hasKeyBeforeDelete, testName, msg);
  Assert.assert(false, hasKeyAfterDelete, testName, msg);
}

fun void testOrderedObjectMapDelete() {
  // setup
  "testOrderedObjectMapDelete" => string testName;
  "delete() remvoes key from map" => string msg;

  "key" => string key;
  "arg" => string argName; 
  100 => int argVal;
  IntArg I;
  I.make(argName, argVal) @=> IntArg arg;

  OrderedObjectMap m;
  m.put(key, arg);
  m.hasKey(key) => int hasKeyBeforeDelete;
  
  // call
  m.delete(key);
  m.hasKey(key) => int hasKeyAfterDelete;

  // assert
  Assert.assert(true, hasKeyBeforeDelete, testName, msg);
  Assert.assert(false, hasKeyAfterDelete, testName, msg);
}

fun void testOrderedArgMapReset() {
  // setup
  "testOrderedArgMapReset" => string testName;
  "reset() removes all keys from map" => string msg;

  IntArg I;
  "key" => string key;
  "arg" => string argName; 
  100 => int argVal;
  I.make(argName, argVal) @=> IntArg arg;

  "key2" => string key2;
  "arg2" => string argName2; 
  101 => int argVal2;
  I.make(argName2, argVal2) @=> IntArg arg2;

  OrderedArgMap m;
  m.put(key, arg);
  m.put(key2, arg2);

  // assert keys, values before reset 
  Assert.assert(true, m.hasKey(key), testName, msg);
  Assert.assert(true, m.hasKey(key2), testName, msg);
  Assert.assert(100, m.get(key).intVal, testName, msg);
  Assert.assert(101, m.get(key2).intVal, testName, msg);

  // call
  m.reset(); 

  // assert keys, values gone after reset 
  Assert.assert(false, m.hasKey(key), testName, msg);
  Assert.assert(false, m.hasKey(key2), testName, msg);
  Assert.assert(0, m.size(), testName, msg);
}

fun void testOrderedObjectMapReset() {
  // setup
  "testOrderedObjectMapReset" => string testName;
  "reset() removes all keys from map" => string msg;

  // call
  IntArg I;
  "key" => string key;
  "arg" => string argName; 
  100 => int argVal;
  I.make(argName, argVal) @=> IntArg arg;

  "key2" => string key2;
  "arg2" => string argName2; 
  101 => int argVal2;
  I.make(argName2, argVal2) @=> IntArg arg2;

  OrderedObjectMap m;
  m.put(key, arg);
  m.put(key2, arg2);

  // assert keys before reset 
  Assert.assert(true, m.hasKey(key), testName, msg);
  Assert.assert(true, m.hasKey(key2), testName, msg);

  // clear
  m.reset(); 

  // assert keys, values gone after reset 
  Assert.assert(false, m.hasKey(key), testName, msg);
  Assert.assert(false, m.hasKey(key2), testName, msg);
  Assert.assert(0, m.size(), testName, msg);
}

fun void testOrderedArgMapKeysValues() {
  // setup
  "testOrderedArgMapKeysValues" => string testName;
  "keys() returns all keys in map as array in order, values() returns all values in map as array in order" => string msg;

  IntArg I;
  "key" => string key;
  "arg" => string argName; 
  100 => int argVal;
  I.make(argName, argVal) @=> IntArg arg;

  "key2" => string key2;
  "arg2" => string argName2; 
  101 => int argVal2;
  I.make(argName2, argVal2) @=> IntArg arg2;

  OrderedArgMap m;
  m.put(key, arg);
  m.put(key2, arg2);

  // call
  m.getKeys() @=> string keys[];
  m.getValues() @=> ArgBase values[];

  /* // assert */
  Assert.assert("key", keys[0], testName, msg);
  Assert.assert("key2", keys[1], testName, msg);
  Assert.assert(2, values.size(), testName, msg);
  Assert.assert(arg.intVal, values[0].intVal, testName, msg);
  Assert.assert(arg2.intVal, values[1].intVal, testName, msg);
}

fun void testOrderedObjectMapKeysValues() {
  // setup
  "testOrderedArgMapKeysValues" => string testName;
  "keys() returns all keys in map as array in order, values() returns all values in map as array in order" => string msg;

  IntArg I;
  "key" => string key;
  "arg" => string argName; 
  100 => int argVal;
  I.make(argName, argVal) @=> IntArg arg;

  "key2" => string key2;
  "arg2" => string argName2; 
  101 => int argVal2;
  I.make(argName2, argVal2) @=> IntArg arg2;

  OrderedObjectMap m;
  m.put(key, arg);
  m.put(key2, arg2);
  
  // call
  m.getKeys() @=> string keys[];
  m.getValues() @=> Object values[];

  // assert
  Assert.assert("key", keys[0], testName, msg);
  Assert.assert("key2", keys[1], testName, msg);
  Assert.assert(2, values.size(), testName, msg);
  values[0] $ ArgBase @=> ArgBase firstVal;
  Assert.assert(arg.intVal, firstVal.intVal, testName, msg);
  values[1] $ ArgBase @=> ArgBase secondVal;
  Assert.assert(arg2.intVal, secondVal.intVal, testName, msg);
}

fun void testOrderedArgMapNextResetNext() {
  // setup
  "testOrderedArgMapNextResetNext" => string testName;
  "next() advances to next key and value, resetNext() resets index" => string msg;

  IntArg I;
  "key" => string key;
  "arg" => string argName; 
  100 => int argVal;
  I.make(argName, argVal) @=> IntArg arg;

  "key2" => string key2;
  "arg2" => string argName2; 
  101 => int argVal2;
  I.make(argName2, argVal2) @=> IntArg arg2;

  OrderedArgMap m;
  m.put(key, arg);
  m.put(key2, arg2);

  // call
  m.next() @=> ArgBase n0;
  m.next() @=> ArgBase n1;
  m.next() @=> ArgBase n2;
  m.resetNext();
  m.next() @=> ArgBase n0AfterReset;
  
  // assert
  Assert.assert(100, n0.intVal, testName, msg);
  Assert.assert(101, n1.intVal, testName, msg);
  Assert.assert(true, n2 == null, testName, msg);
}

fun void testOrderedObjectMapNextResetNext() {
  // setup
  "testOrderedObjectMapNextResetNext" => string testName;
  "next() advances to next key and value, resetNext() resets index" => string msg;

  IntArg I;
  "key" => string key;
  "arg" => string argName; 
  100 => int argVal;
  I.make(argName, argVal) @=> IntArg arg;

  "key2" => string key2;
  "arg2" => string argName2; 
  101 => int argVal2;
  I.make(argName2, argVal2) @=> IntArg arg2;

  OrderedObjectMap m;
  m.put(key, arg);
  m.put(key2, arg2);

  // call
  m.next() $ ArgBase @=> ArgBase n0;
  m.next() $ ArgBase @=> ArgBase n1;
  m.next() $ArgBase @=> ArgBase n2;
  m.resetNext();
  m.next() $ ArgBase @=> ArgBase n0AfterReset;
  
  // assert
  Assert.assert(100, n0.intVal, testName, msg);
  Assert.assert(101, n1.intVal, testName, msg);
  Assert.assert(true, n2 == null, testName, msg);
}

fun void test() {
  <<< "\nRunning Test Suite:", TEST_SUITE >>>;
  testOrderedArgMapPutGetSize();
  testOrderedObjectMapPutGetSize();
  testOrderedArgMapHasKey();
  testOrderedObjectMapHasKey();
  testOrderedArgMapDelete();
  testOrderedObjectMapDelete();
  testOrderedArgMapReset();
  testOrderedObjectMapReset();
  testOrderedArgMapKeysValues();
  testOrderedObjectMapKeysValues();
  testOrderedArgMapNextResetNext();
}

test();
