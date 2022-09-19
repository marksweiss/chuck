// cli: chuck test/assert.ck lib/arg_parser/arg_base.ck lib/arg_parser/int_arg.ck lib/arg_parser/float_arg.ck \
//            lib/arg_parser/string_arg.ck lib/arg_parser/duration_arg.ck lib/arg_parser/time_arg.ck \
//            lib/arg_parser/arg_parser.ck \
//            test/lib/arg_parser/arg_parser_test.ck

"Test ArgParser" => string TEST_SUITE;

fun void testAddIntArgHasArg() {
  // setup
  "testAddIntArgHasArg" => string testName;
  "parser has arg with given name" => string msg;
  
  ArgParser argParser;
  "newIntArg" => string argName;

  // call
  argParser.addIntArg(argName, 100) @=> IntArg arg;
  // assert val
  Assert.assert(100, arg.intVal, testName, msg);

  // call hasArg
  argParser.hasArg(arg.nameToFlag()) => int actual;
  // assert hasArg
  true => int expected;
  Assert.assert(expected, actual, testName, msg);
}

fun void testAddFloatArgHasArg() {
  // setup
  "testAddFloatArgHasArg" => string testName;
  "parser has arg with given name" => string msg;
  
  ArgParser argParser;
  "newFloatArg" => string argName;

  // call
  argParser.addFloatArg(argName, 100.0) @=> FloatArg arg;
  // assert val
  Assert.assert(100.0, arg.fltVal, testName, msg);

  // call hasArg
  argParser.hasArg(arg.nameToFlag()) => int actual;
  // assert hasArg
  true => int expected;
  Assert.assert(expected, actual, testName, msg);
}

fun void testAddStringArgHasArg() {
  // setup
  "testAddStringArgHasArg" => string testName;
  "parser has arg with given name" => string msg;
  
  ArgParser argParser;
  "newStringArg" => string argName;

  // call
  argParser.addStringArg(argName, "100") @=> StringArg arg;
  // assert val
  Assert.assert("100", arg.strVal, testName, msg);

  // call hasArg
  argParser.hasArg(arg.nameToFlag()) => int actual;
  // assert hasArg
  true => int expected;
  Assert.assert(expected, actual, testName, msg);
}

fun void testAddDurationArgHasArg() {
  // setup
  "testAddDurationArgHasArg" => string testName;
  "parser has arg with given name" => string msg;
  
  ArgParser argParser;
  "newDurationArg" => string argName;

  // call
  argParser.addDurationArg(argName, 100::ms) @=> DurationArg arg;
  // assert val
  Assert.assert(100::ms, arg.durVal, testName, msg);

  // call hasArg
  argParser.hasArg(arg.nameToFlag()) => int actual;
  // assert hasArg
  true => int expected;
  Assert.assert(expected, actual, testName, msg);
}

fun void testAddTimeArgHasArg() {
  // setup
  "testAddTimeArgHasArg" => string testName;
  "parser has arg with given name" => string msg;
  
  ArgParser argParser;
  "newTimeArg" => string argName;

  // call
  argParser.addTimeArg(argName, 100::ms + now) @=> TimeArg arg;
  // assert val
  Assert.assert(100::ms + now, arg.timeVal, testName, msg);

  // call hasArg
  argParser.hasArg(arg.nameToFlag()) => int actual;
  // assert hasArg
  true => int expected;
  Assert.assert(expected, actual, testName, msg);
}

fun void testHasArgNotFound() {
  // setup
  "testAddArgHasArgNotFound" => string testName;
  "parser does note have arg with given name" => string msg;
  
  ArgParser argParser;
  "newIntArg" => string argName;
  false => int expected;

  // call
  argParser.hasArg("--new-int-arg") => int actual;

  // assert
  Assert.assert(expected, actual, testName, msg);
}

fun void testNumArgs() {
  // setup
  "testNumArgs" => string testName;
  "numArgs matches number of calls made to add arg" => string msg;

  ArgParser argParser;

  // assert numArgs == 0 before any args added
  Assert.assert(0, argParser.numArgs, testName, msg);

  // add an arg and assert == 1
  argParser.addStringArg("newStringArg", "100");
  Assert.assert(1, argParser.numArgs, testName, msg);
  
  // add an arg and assert == 2
  argParser.addIntArg("newIntArg", 100);
  Assert.assert(2, argParser.numArgs, testName, msg);
}

fun void test() {
  <<< "\nRunning Test Suite:", TEST_SUITE >>>;
  testAddIntArgHasArg();
  testAddFloatArgHasArg();
  testAddStringArgHasArg();
  testAddDurationArgHasArg();
  testAddTimeArgHasArg();
  testHasArgNotFound();
  testNumArgs();
}

test();
