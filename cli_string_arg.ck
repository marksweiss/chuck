public class CliStringArg extends CliArgBase {
  CLI_ARG_STRING => static int type;

  /**
   * Factory method ot make an from a name and a value
   */
  fun static CliStringArg make(string name, string val) {
    CliStringArg arg;
    name => arg.name;
    val => arg.strVal;
    return arg;
  }
}

CliStringArg.make("argString", "Hello and Goodbye") @=> CliStringArg arg;
<<< arg.name, arg.nameToFlag(), arg.type, "\"", arg.strVal, "\"" >>>;

