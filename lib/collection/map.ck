/* Machine.add("lib/arg_parser/arg_base.ck"); */
/* Machine.add("lib/arg_parser/int_arg.ck"); */
/* Machine.add("lib/arg_parser/float_arg.ck"); */
/* Machine.add("lib/arg_parser/string_arg.ck"); */
/* Machine.add("lib/arg_parser/arg_parser.ck"); */

/**
 * Stores key/values with Map semantics. Keys are strings and values are subtypes of
 * ArgBase. Thus values are polymporhic. The data structure also stores key/values in
 * the order keys are originally added, which is stable even if put() is later called
 * on a previously added key; in that case the key retains its position but the
 * associated value is replaced.
 */
// TODO TEST
public class OrderedMap {
  128 => int MAX_NUM_KEYS;
  string keys[MAX_NUM_KEYS];
  int map[1];
  0 => int count;

  // iterator support
  0 => int nextIdx;
  // sentinel value for next(), expect user to loop and check
  // Supports client syntax: while (map.next(i) != OrderedMap.END) {...}
  -1 => static int END;

  fun void put(string key, ArgBase val) {
    // if key already present, clear value for key, don't add key to keys
    if (keys.find(key) == 1) {
      map.erase(key);
    // else new key, add key to keys
    } else {
      keys[count] @=> key;
      count++;
    }
    // set value for key
    map[key] @=> val;
  }

  fun ArgBase get(string key) {
    return map[key];
  }

  fun int hasKey(string key) {
    return keys.find(key) == 1;
  }

  fun void delete(string key) {
    map.clear(key);
  }

  fun void reset() {
    // clear() instead of reset() because reset() resizes storage to 8 elements
    keys.clear();
    map.reset();
  }

  fun string[] keys() {
    return keys;
  }

  fun ArgBase[] values() {
    ret ArgBase[count];
    for (0 => int i; i < count; i++) {
      map[keys[i]] @=> ret[i]; 
    }
    return ret;
  }

  fun int size() {
    return count;
  }

  fun ArgBase next() {
    // if we reach the end, reset iterator state and return sentinel
    if (nextIdx == count - 1) {
      0 => nextIdx;
      return END;
    }
    // else return value at current position and advance position
    return map[keys[nextIdx]];
    nextIdx++;
  }

  fun void resetNext() {
    0 => nextIdx;
  }
}
