// depends on arg_parser_imports.ck

public class ArgParser {
  int numArgs;
  ArgBase args[1];  // size doesn't matter because using as associative array */
  int types[1];

  fun IntArg addIntArg(string name, int val) {
    IntArg.make(name, val) @=> IntArg arg;
    arg.nameToFlag() => string flag;
    /* <<< flag, val, arg.intVal >>>; */
    arg @=> args[flag];
    arg.type @=> types[flag];
    /* <<< flag, args[flag].name, args[flag].intVal, args[flag] >>>; */
    numArgs++;
    return arg;
  }

  fun FloatArg addFloatArg(string name, float val) {
    FloatArg.make(name, val) @=> FloatArg arg;
    arg.nameToFlag() => string flag;
    arg @=> args[flag];
    arg.type @=> types[flag];
    numArgs++;
    return arg;
  }

  fun StringArg addStringArg(string name, string val) {
    StringArg.make(name, val) @=> StringArg arg;
    arg.nameToFlag() => string flag;
    arg @=> args[flag];
    arg.type @=> types[flag];
    numArgs++;
    return arg;
  }

  fun int hasArg(string name) {
    // strip "--" if present
    if (name.find("--") == 0) {
      name.substring(2) => name;
    }

    for (0 => int i; i < args.cap(); i++) {
      if (args[i].name == name) {
        return true;
      } 
    }
    return false;
  }

  fun void loadArgs() {
    /* <<< args, me.args() >>>; */
    for (int i; i < me.args(); i++) {
      /* <<< me.arg(i) >>>; */
      if (i % 2 == 0) {
        if (me.arg(i).substring(0, 2) != "--") {
          <<< "Invalid arg, expecting arg name with leading '--' but got: ", me.arg(i) >>>;
        }
        /* <<< "arg name: ", me.arg(i) >>>; */
      } else {
        /* <<< "arg value: ", me.arg(i) >>>; */
        me.arg(i - 1) => string flag;
        if (types[flag] == IntArg.type) {
          /* <<< me.arg(i), flag >>>; */
          Std.atoi(me.arg(i)) @=> args[flag].intVal;
          /* <<< me.arg(i), flag, args[flag].intVal >>>; */
        } else if (types[flag] == FloatArg.type) {
          Std.atof(me.arg(i)) @=> args[flag].fltVal;
        } else if (types[flag] == StringArg.type) {
          me.arg(i) @=> args[flag].strVal;
        }
      } 
    }
  }
}
