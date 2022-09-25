public class FloatArg extends ArgBase {
  ARG_FLOAT => static int type;

  /**
   * Factory method ot make an from a name and a value
   */
  fun static FloatArg make(string name, float val) {
    FloatArg arg;
    name => arg.name; 
    val => arg.fltVal;
    return arg;
  }
}
