public class ArgBase {
  // type enums to suport asking an arg for its value type
  0 => static int ARG_INT;
  1 => static int ARG_FLOAT;
  2 => static int ARG_STRING;
  3 => static int ARG_DURATION;
  4 => static int ARG_TIME;

  string name;
  int intVal;
  float fltVal;
  string strVal;
  dur durVal;
  time timeVal

  /**
   * Converts a camelcase arg name to a *nix-style flag syntax
   */
  fun string nameToFlag() {
    "" @=> string flag;
    for (0 => int i; i < name.length(); ++i) {
      // insert '-' where there is an upper-case character and make that character lower case
      if (name.substring(i, 1) == name.substring(i, 1).upper()) {
        // just use rtrim() to generate a copy of the string
        flag.rtrim() + "-" + name.substring(i, 1).lower() @=> string temp;
        temp @=> flag;
      } else {
        flag.rtrim() + name.substring(i, 1) @=> string temp;
        temp @=> flag;
      }
    }
    
    return "--" + flag;
  }
}
