public class Assert {

  0.00001 => static float EPSILON;

  fun static void assert(int expected, int actual, string testName, string msg) {
    if (expected != actual) {
      <<< testName, "FAILED for expected:", expected, "actual:", actual >>>;
      printFailMsg(msg);
      fail();
    }
    printSuccess(testName);
  }

  fun static void assert(string expected, string actual, string testName, string msg) {
    if (expected != actual) {
      <<< testName, "FAILED for expected:", expected, "actual:", actual >>>;
      printFailMsg(msg);
      fail();
    }
    printSuccess(testName);
  }

  fun static void assert(dur expected, dur actual, string testName, string msg) {
    if (expected != actual) {
      <<< testName, "FAILED for expected:", expected, "actual:", actual >>>;
      printFailMsg(msg);
      fail();
    }
    printSuccess(testName);
  }

  fun static void assert(time expected, time actual, string testName, string msg) {
    if (expected != actual) {
      <<< testName, "FAILED for expected:", expected, "actual:", actual >>>;
      printFailMsg(msg);
      fail();
    }
    printSuccess(testName);
  }

  fun static void assert(float expected, float actual, string testName, string msg) {
    // absolute value of the difference between the two floats tested for being below threshold
    if (!assertFloatEqual(expected, actual)) {
      <<< testName, "FAILED for expected:", expected, "actual:", actual >>>;
      printFailMsg(msg);
      fail();
    }
    printSuccess(testName);
  }

  fun static int assertFloatEqual(float expected, float actual) {
    // hacky but the return value from remainder, at least as printed in the VM process,
    // has six digits of precision, and all logical comparisons with floats fail
    return ((Math.fabs(Math.remainder(expected, actual)) * 100000) $ int) == 0;
  }

  fun /*private*/ static void printFailMsg(string msg) {
    if (msg.length() > 0) {
      <<< "Additional info:", msg >>>;
    }
  }

  fun /*private*/ static void fail() {
    me.exit();
  }
  
  fun /*private*/ static void printSuccess(string testName) {
    <<< "SUCCESS", testName >>>;
  }
}
