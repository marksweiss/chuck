public class Assert {

  0.0000001 => static float EPSILON;

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
    if (Math.fabs(Math.remainder(expected, actual)) > EPSILON) {
      <<< testName, "FAILED for expected:", expected, "actual:", actual >>>;
      printFailMsg(msg);
      fail();
    }
    printSuccess(testName);
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
