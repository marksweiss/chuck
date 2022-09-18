public class TimeArg extends ArgBase {
  ARG_TIME => static int type;

  /**
   * Factory method ot make an from a name and a value
   */
  fun static TimeArg make(string name, time val) {
    TimeArg arg;
    name => arg.name; 
    val => arg.timeVal;
    return arg;
  }
}
