public class DurationArg extends ArgBase {
  ARG_DURATION => static int type;

  /**
   * Factory method ot make an from a name and a value
   */
  fun static DurationArg make(string name, dur val) {
    DurationArg arg;
    name => arg.name; 
    val => arg.durVal;
    return arg;
  }
}
