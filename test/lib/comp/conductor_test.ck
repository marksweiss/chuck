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

fun void test() {
  <<< "\nRunning Test Suite:", TEST_SUITE >>>;
  testPutGet();
}

test();
