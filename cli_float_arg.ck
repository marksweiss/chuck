public class CliFloatArg extends CliArgBase {
  CLI_ARG_FLOAT => static int type;

  /**
   * Factory method ot make an from a name and a value
   */
  fun static CliFloatArg make(string name, float val) {
    CliFloatArg arg;
    name => arg.name; 
    val => arg.fltVal;
    return arg;
  }
}

CliFloatArg.make("argFloat", 20.01) @=> CliFloatArg arg; 
<<< arg.name, arg.nameToFlag(), arg.type, arg.fltVal >>>;
