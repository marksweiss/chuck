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

  fun static void assert(int expected[], int actual[], string testName, string msg) {
    if (expected.size() != actual.size()) {
      printArrayLenghFailMsg(testName);
      fail();
    }
    for (0 => int i; i < expected.size(); i++) {
      assert(expected[i], actual[i], testName, msg);
    }
  }

  fun static void assert(string expected, string actual, string testName, string msg) {
    if (expected != actual) {
      <<< testName, "FAILED for expected:", expected, "actual:", actual >>>;
      printFailMsg(msg);
      fail();
    }
    printSuccess(testName);
  }

  fun static void assert(string expected[], string actual[], string testName, string msg) {
    if (expected.size() != actual.size()) {
      printArrayLenghFailMsg(testName);
      fail();
    }
    for (0 => int i; i < expected.size(); i++) {
      assert(expected[i], actual[i], testName, msg);
    }
  }

  fun static void assert(dur expected, dur actual, string testName, string msg) {
    if (expected != actual) {
      <<< testName, "FAILED for expected:", expected, "actual:", actual >>>;
      printFailMsg(msg);
      fail();
    }
    printSuccess(testName);
  }

  fun static void assert(dur expected[], dur actual[], string testName, string msg) {
    if (expected.size() != actual.size()) {
      printArrayLenghFailMsg(testName);
      fail();
    }
    for (0 => int i; i < expected.size(); i++) {
      assert(expected[i], actual[i], testName, msg);
    }
  }

  fun static void assert(time expected, time actual, string testName, string msg) {
    if (expected != actual) {
      <<< testName, "FAILED for expected:", expected, "actual:", actual >>>;
      printFailMsg(msg);
      fail();
    }
    printSuccess(testName);
  }

  fun static void assert(time expected[], time actual[], string testName, string msg) {
    if (expected.size() != actual.size()) {
      printArrayLenghFailMsg(testName);
      fail();
    }
    for (0 => int i; i < expected.size(); i++) {
      assert(expected[i], actual[i], testName, msg);
    }
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

  fun static void assert(float expected[], float actual[], string testName, string msg) {
    if (expected.size() != actual.size()) {
      printArrayLenghFailMsg(testName);
      fail();
    }
    for (0 => int i; i < expected.size(); i++) {
      assert(expected[i], actual[i], testName, msg);
    }
  }

  fun static void validate(int val, int min, int max) {
    if (!(min < val) || !(val < max)) {
      <<< val, "not between", min, "and", max >>>;
      fail();
    }
  }

  fun static void validate(dur val, dur min, dur max) {
    if (!(min < val) || !(val < max)) {
      <<< val, "not between", min, "and", max >>>;
      fail();
    }
  }

  fun static void validate(time val, time min, time max) {
    if (!(min < val) || !(val < max)) {
      <<< val, "not between", min, "and", max >>>;
      fail();
    }
  }

  fun static void validate(float val, float min, float max) {
    if (!assertFloatLessThan(min, val) || !assertFloatGreaterThan(max, val)) {
      <<< val, "not between", min, "and", max >>>;
      fail();
    }
  }

  fun /*private*/ static int assertFloatEqual(float expected, float actual) {
    // hacky but the return value from remainder, at least as printed in the VM process,
    // has six digits of precision, and all logical comparisons with floats fail
    return ((Math.fabs(Math.remainder(expected, actual)) * 100000) $ int) == 0;
  }

  // TODO TEST
  fun /*private*/ static int assertFloatLessThan(float left, float right) {
    /* return ((Math.remainder(left, right) * 100000) $ int) < 0; */
    return assertFloatEqual(Math.max(left, right), right);
  }

  // TODO TEST
  fun /*private*/ static int assertFloatGreaterThan(float left, float right) {
    /* return ((Math.remainder(left, right) * 100000) $ int) > 0; */
    return assertFloatEqual(Math.max(left, right), left);
  }

  fun /*private*/ static void printFailMsg(string msg) {
    if (msg.length() > 0) {
      <<< "Additional info:", msg >>>;
    }
  }

  fun /*private*/ static void printArrayLenghFailMsg(string testName) {
    <<< testName, "FAILED array lengths don't match" >>>;
  }

  fun /*private*/ static void fail() {
    me.exit();
  }
  
  fun /*private*/ static void printSuccess(string testName) {
    <<< "SUCCESS", testName >>>;
  }
}
