// cli: chuck test/assert.ck lib/arg_parser/arg_base.ck
//            lib/arg_parser/int_arg.ck lib/arg_parser/float_arg.ck lib/arg_parser/string_arg.ck
//             lib/arg_parser/duration_arg.ck lib/arg_parser/time_arg.ck
//            lib/collection/arg_map.ck lib/comp/conductor.ck
//            test/lib/comp/conductor_test.ck

"Test Conductor" => string TEST_SUITE;

fun void testPutGet() {
  // setup
  "testPutGet" => string testName;
  "put() should add key/value pair of string/value for supported value types" => string msg;
  
  Conductor conductor;
  100 => int intVal;  
  101.5 => float floatVal;
  "val" => string strVal;
  1::second => dur durVal;
  now => time timeVal;
  me.id() => int shredId;
   
  // call 
  conductor.put(shredId, "intVal", intVal);
  conductor.put(shredId, "floatVal", floatVal);
  conductor.put(shredId, "strVal", strVal);
  conductor.put(shredId, "durVal", durVal);
  conductor.put(shredId, "timeVal", timeVal);

  // assert
  Assert.assert(conductor.get(shredId, "intVal").intVal, intVal, testName, msg);
  Assert.assert(conductor.get(shredId, "floatVal").fltVal, floatVal, testName, msg);
  Assert.assert(conductor.get(shredId, "strVal").strVal, strVal, testName, msg);
  Assert.assert(conductor.get(shredId, "durVal").durVal, durVal, testName, msg);
  Assert.assert(conductor.get(shredId, "timeVal").timeVal, timeVal, testName, msg);
}

fun void testSize() {
  // setup
  "testSize" => string testName;
  "size() should return the number of shreds with mapped args" => string msg;
  
  Conductor conductor;
  100 => int intVal;  
  101.5 => float floatVal;
  me.id() => int shredId;
   
  // call 
  conductor.put(shredId, "intVal", intVal);
  conductor.put(shredId, "floatVal", floatVal);

  // assert
  1 => int expectedSize;
  Assert.assert(conductor.size(), expectedSize, testName, msg);
}

fun void testSizeKeySize() {
  // setup
  "testSizeKeySize" => string testName;
  "keySize() should return the number of keys added across all shreds" => string msg;
  
  Conductor conductor;
  100 => int intVal;  
  101.5 => float floatVal;
  me.id() => int shredId;
  shredId + 1 => int anotherShredId;
   
  // call 
  conductor.put(shredId, "intVal", intVal);
  conductor.put(shredId, "floatVal", floatVal);
  conductor.put(anotherShredId, "intVal", intVal);
  conductor.put(anotherShredId, "floatVal", floatVal);

  // assert
  2 => int expectedSize;
  4 => int expectedKeySize;
  Assert.assert(conductor.size(), expectedSize, testName, msg);
  Assert.assert(conductor.keySize(), expectedKeySize, testName, msg);
}

fun void testGetKeys() {
  // setup
  "testGetKeys" => string testName;
  "getKeys() should the set of all added keys as a string[] in order of insertion" => string msg;
  
  Conductor conductor;
  "intKey" => string intKey;
  "fltKey" => string fltKey;
  "strKey" => string strKey;
  "durKey" => string durKey;
  "timeVal" => string timeKey;
  100 => int intVal;  
  101.5 => float floatVal;
  "val" => string strVal;
  1::second => dur durVal;
  now => time timeVal;
  me.id() => int shredId;
   
  // call 
  conductor.put(shredId, intKey, intVal);
  conductor.put(shredId, fltKey, floatVal);
  conductor.put(shredId, strKey, strVal);
  conductor.put(shredId, durKey, durVal);
  conductor.put(shredId, timeKey, timeVal);

  // assert
  [intKey, fltKey, strKey, durKey, timeKey] @=> string expectedKeys[];
  Assert.assert(conductor.getKeys(), expectedKeys, testName, msg);
}

fun void test() {
  <<< "\nRunning Test Suite:", TEST_SUITE >>>;
  testPutGet();
  testSize();
  testSizeKeySize();
  testGetKeys();
}

test();
