// depends on arg_parser_imports.ck

/*
* Arg names and values are seperated by colons
* Example:
*  chuck midi_example.ck:--controller-port-in:0:--controller-port-out:1: \
*    --internal-port-out:1:--channel-in:1:--channel-out:2  
*/

public class ArgParser {
  // used to store keyNames only
  128 => static int MAX_NUM_ARGS;
  // redundant array of associative array arg key names because Chuck doesn't support retrieving
  // or iterating over keys etc., and we want to support pattern matching on keys, that is, support
  // checking for a key without being able to match on the exact key name
  string keyNames[MAX_NUM_ARGS];

  int numArgs;
  ArgBase args[1];  // size doesn't matter because using as associative array */
  int types[1];

  fun IntArg addIntArg(string name, int val) {
    IntArg.make(name, val) @=> IntArg arg;
    arg.toFlag() => string flag;
    arg @=> args[flag];
    arg.type @=> types[flag];
    flag @=> keyNames[numArgs];
    numArgs++;
    return arg;
  }

  fun FloatArg addFloatArg(string name, float val) {
    FloatArg.make(name, val) @=> FloatArg arg;
    arg.toFlag() => string flag;
    arg @=> args[flag];
    arg.type @=> types[flag];
    flag @=> keyNames[numArgs];
    numArgs++;
    return arg;
  }

  fun StringArg addStringArg(string name, string val) {
    StringArg.make(name, val) @=> StringArg arg;
    arg.toFlag() => string flag;
    arg @=> args[flag];
    arg.type @=> types[flag];
    flag @=> keyNames[numArgs];
    numArgs++;
    return arg;
  }

  fun DurationArg addDurationArg(string name, dur val) {
    DurationArg.make(name, val) @=> DurationArg arg;
    arg.toFlag() => string flag;
    arg @=> args[flag];
    arg.type @=> types[flag];
    flag @=> keyNames[numArgs];
    numArgs++;
    return arg;
  }

  fun TimeArg addTimeArg(string name, time val) {
    TimeArg.make(name, val) @=> TimeArg arg;
    arg.toFlag() => string flag;
    arg @=> args[flag];
    arg.type @=> types[flag];
    flag @=> keyNames[numArgs];
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

  fun int hasAnyArg(string namesToMatch[]) {
    for (0 => int i; i < namesToMatch.size(); i++) {
      if (args.find(namesToMatch[i]) > 1) {
        <<< "arg name key found more than once" >>>;
        me.exit();
      }
      if (args.find(namesToMatch[i]) == 1) {
        return true;
      }
    }
    return false;
  }

  /**
   * Matches any argument that *starts* with prefixPattern. Supports "families" of arguments.
   */
  fun int hasAnyArg(string prefixPattern) {
    for (0 => int i; i < keyNames.size(); i++) {
      if (keyNames[i].find(prefixPattern) == 0) {
        return true;
      }
    }
    return false;
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
