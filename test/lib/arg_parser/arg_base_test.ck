// cli: chuck lib/test/assert.ck lib/arg_parser/arg_base.ck test/lib/arg_parser/arg_base_test.ck

"Test ArgBase" => string TEST_SUITE;

fun void testNameToFlagSingleWordName() {
  // setup
  "testNameToFlagSingleWordName" => string testName;
  "single-word name" => string msg;

  ArgBase argBase;
  "flag"  => argBase.name;
  "--flag" => string expected;

  // call
  argBase.nameToFlag() => string actual;

  // assert
  Assert.assert(expected, actual, testName, msg);
}

fun void testNameToFlag() {
  // setup
  "testNameToFlag" => string testName;
  "multiple-word name" => string msg;

  ArgBase argBase;
  "flagWithMoreWords"  => argBase.name;
  "--flag-with-more-words" => string expected;

  // call
  argBase.nameToFlag() => string actual;

  // assert
  Assert.assert(expected, actual, testName, msg);
}

fun void test() {
  <<< "\nRunning Test Suite:", TEST_SUITE >>>;
  testNameToFlagSingleWordName();
  testNameToFlag();
}

test();
