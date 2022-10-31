public class ArgBase {
  // type enums to suport asking an arg for its value type
  0 => static int ARG_INT;
  1 => static int ARG_FLOAT;
  2 => static int ARG_STRING;
  3 => static int ARG_DURATION;
  4 => static int ARG_TIME;

  "DUMMY_NAME" => string DUMMY_NAME;
  -1 => static int DUMMY_VALUE;

  string name;
  int intVal;
  float fltVal;
  string strVal;
  dur durVal;
  time timeVal;

  // non-static because string DUMMY_NAME cannot be static in Chuck
  fun /*static*/ ArgBase makeEmpty() {
    ArgBase ret;
    DUMMY_NAME => ret.name; 
    DUMMY_VALUE => intVal;
    return ret;
  }

  /**
   * Converts a camelcase arg name to a *nix-style flag syntax
   */
  fun string toFlag() {
    return toFlag(this.name);
  }

  fun static string toFlag(string name) {
    if (name.length() == 0) {
      <<< "name must not be empty string" >>>;
      me.exit(); 
    }

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
