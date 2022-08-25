public class CliStringArg extends CliArgBase {
  STRING => type;
  string val;

  /**
   * Factory method ot make an from a name and a value
   */
  fun static CliStringArg make(string name, string val) {
    CliStringArg arg;
    arg.init(name);
    val => arg.val;
    return arg;
  }
}

CliStringArg.make("argString", "Hello and Goodbye") @=> CliStringArg arg;
<<< arg.name, arg.nameToFlag(), arg.type, "\"", arg.val, "\"" >>>;

