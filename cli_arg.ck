class CliArgBase {
  // type enums to suport asking an arg for its value type
  0 => int INT;
  1 => int FLOAT;
  2 => int STRING;

  string name;
  string val;
  int type;

  /**
   * name_ - name of the argument
   * val_ - the value of the argument, as a string (passed in from the command line as a string)
   */
  fun void init(string name_, string val_) {
    name_ => name;
    val_ => val;
  }

  /**
   * Converts a camelcase arg name to a *nix-style flag syntax, e.g. 'argOne' => '--arg-one'
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

class CliIntArg extends CliArgBase {
  INT => type;

  fun int getVal() {
    return val.toInt();
  }
}

class CliFloatArg extends CliArgBase {
  FLOAT => type;

  fun float getVal() {
    return val.toFloat();
  }
}

class CliStringArg extends CliArgBase {
  STRING => type;

  fun string getVal() {
    return val;
  }
}

CliIntArg cliIntArg;
cliIntArg.init("argInt", "10");
<<< cliIntArg.name, cliIntArg.nameToFlag(), cliIntArg.type, cliIntArg.getVal() >>>;

CliFloatArg cliFloatArg;
cliFloatArg.init("argFloat", "20.01");
<<< cliFloatArg.name, cliFloatArg.nameToFlag(), cliFloatArg.type, cliFloatArg.getVal() >>>;

CliStringArg cliStrArg;
cliStrArg.init("argString", "Hello and Goodbye");
<<< cliStrArg.name, cliStrArg.nameToFlag(), cliStrArg.type, "\"", cliStrArg.getVal(), "\"" >>>;

