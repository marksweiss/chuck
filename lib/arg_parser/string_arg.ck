public class StringArg extends ArgBase {
  ARG_STRING => static int type;

  /**
   * Factory method ot make an from a name and a value
   */
  fun static StringArg make(string name, string val) {
    StringArg arg;
    name => arg.name;
    val => arg.strVal;
    return arg;
  }
}

/* StringArg.make("argString", "Hello and Goodbye") @=> StringArg arg; */
/* <<< arg.name, arg.nameToFlag(), arg.type, "\"", arg.strVal, "\"" >>>; */
