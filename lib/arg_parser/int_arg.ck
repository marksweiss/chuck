// Machine.add("lib/arg_parser/arg_base.ck")

public class IntArg extends ArgBase {
  ARG_INT => static int type;

  /**
   * Factory method to make an arg from a name and a value
   */
  fun static IntArg make(string name, int val) {
    IntArg arg;
    name => arg.name;
    val => arg.intVal;
    return arg;
  }
}
