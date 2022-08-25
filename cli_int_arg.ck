public class CliIntArg extends CliArgBase {
  INT => type;
  int val;

  /**
   * Factory method ot make an from a name and a value
   */
  fun static CliIntArg make(string name, int val) {
    CliIntArg arg;
    arg.init(name);
    val => arg.val;
    return arg;
  }
}

CliIntArg.make("argInt", 10) @=> CliIntArg arg;
<<< arg.name, arg.nameToFlag(), arg.type, arg.val >>>;
