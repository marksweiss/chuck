// depends on arg_parser_imports.ck

/*
* Arg names and values are seperated by colons
* Example:
*  chuck midi_example.ck:--controller-port-in:0:--controller-port-out:1: \
*    --internal-port-out:1:--channel-in:1:--channel-out:2  
*/

public class ArgParser {
  int numArgs;
  ArgBase args[1];  // size doesn't matter because using as associative array */
  int types[1];

  fun IntArg addIntArg(string name, int val) {
    IntArg.make(name, val) @=> IntArg arg;
    arg.nameToFlag() => string flag;
    arg @=> args[flag];
    arg.type @=> types[flag];
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

  fun int hasArg(string nameToMatch) {
    if (args.find(nameToMatch) > 1) {
      <<< "arg name key found more than once" >>>;
      me.exit();
    }
    return args.find(nameToMatch) == 1;
  }

  fun void loadArgs() {
    for (int i; i < me.args(); i++) {
      if (i % 2 == 0) {
        if (me.arg(i).substring(0, 2) != "--") {
          <<< "Invalid arg, expecting arg name with leading '--' but got: ", me.arg(i) >>>;
        }
      } else {
        me.arg(i - 1) => string flag;
        if (types[flag] == IntArg.type) {
          Std.atoi(me.arg(i)) @=> args[flag].intVal;
        } else if (types[flag] == FloatArg.type) {
          Std.atof(me.arg(i)) @=> args[flag].fltVal;
        } else if (types[flag] == StringArg.type) {
          me.arg(i) @=> args[flag].strVal;
        }
      } 
    }
  }
}
