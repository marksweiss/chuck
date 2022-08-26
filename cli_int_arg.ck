public class CliIntArg extends CliArgBase {
  CLI_ARG_INT => static int type;

  /**
   * Factory method ot make an from a name and a value
   */
  fun static CliIntArg make(string name, int val) {
    CliIntArg arg;
    name => arg.name;
    val => arg.intVal;
    return arg;
  }
}

CliIntArg.make("argInt", 10) @=> CliIntArg arg;
<<< arg.name, arg.nameToFlag(), arg.type, arg.intVal >>>;
