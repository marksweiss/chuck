// cli: chuck test/assert.ck lib/arg_parser/arg_base.ck lib/arg_parser/int_arg.ck \
//            lib/collection/arg_map.ck lib/collection/object_map.ck test/lib/collection/map_test.ck

"Test Map" => string TEST_SUITE;

fun void testOrderedArgMapPutGet() {
  // setup
  "testPut" => string testName;
  "put() adds argument key and value to the map" => string msg;

  // call
  "key" => string key;
  "arg" => string argName; 
  100 => int argVal;
  IntArg I;
  I.make(argName, argVal) @=> IntArg arg;

  OrderedArgMap m;
  m.put(key, arg);
  m.get(key) $ IntArg @=> IntArg actualArg;

  // assert
  Assert.assert(m.size(), 1, testName, msg);
  I.make(argName, argVal) @=> IntArg expectedArg;
  Assert.assert(expectedArg.name, actualArg.name, testName, msg);
  Assert.assert(expectedArg.intVal, actualArg.intVal, testName, msg);
}


fun void test() {
  <<< "\nRunning Test Suite:", TEST_SUITE >>>;
  testOrderedArgMapPutGet();
}

test();
