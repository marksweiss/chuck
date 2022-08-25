public class CliFloatArg extends CliArgBase {
  FLOAT => type;
  float val;

  /**
   * Factory method ot make an from a name and a value
   */
  fun static CliFloatArg make(string name, float val) {
    CliFloatArg arg;
    arg.init(name);
    val => val;
    return arg;
  }
}

CliFloatArg.make("argFloat", 20.01) @=> CliFloatArg arg; 
<<< arg.name, arg.nameToFlag(), arg.type, arg.val >>>;
