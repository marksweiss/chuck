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
public class OrderedArgMap {
  128 => int MAX_NUM_KEYS;
  string keys[MAX_NUM_KEYS];
  ArgBase  map[0];
  0 => int count;

  // iterator support
  0 => int nextIdx;
  // sentinel value for next(), expect user to loop and check
  // Supports client syntax: while (map.next(i) != OrderedMap.END) {...}
  -1 => static int END;

  fun void put(string key, ArgBase val) {
    // if key already present, clear value for key, don't add key to keys
    if (map.find(key) == 1) {
      map.erase(key);
    // else new key, add key to keys
    } else {
      key => keys[count++];
    }

    // set value for key
    val @=> map[key];
  }

  fun ArgBase get(string key) {
    return map[key];
  }

  fun int hasKey(string key) {
    return map.find(key) == 1;
  }

  fun void delete(string key) {
    map.erase(key);
    
    // manueally rebuild keys, skipping key being erased, because clear() and reset() don't remove
    // non-associative elements from arrays
    string tempKeys[MAX_NUM_KEYS];
    0 => int j;
    // copy the old keys, skipping the key being erased
    for (0 => int i; i < count; i++) {
      if (keys[i] != key) {
        keys[i] => tempKeys[j];
        j++;
      }
    }
    // blank out all keys in the instance member
    for (0 => int i; i < count; i++) {
      "" => keys[i];
    }
    // copy the new keys from temp back to the instance member
    for (0 => int i; i < tempKeys.size(); i++) {
      tempKeys[i] => keys[i];
    }

    count--;
  }

  fun void reset() {
    // clear() instead of reset() because reset() resizes storage to 8 elements
    keys.clear();
    // clear() and reset() don't remove associative array keys, and erase only removes the value for a key
    // so we have to reallocate.  NOTE: This is probably a memory leak
    null => map;
    ArgBase newMap[0];
    newMap @=> map;

    0 => count;
  }

  fun string[] getKeys() {
    return keys;
  }

  fun ArgBase[] getValues() {
    ArgBase ret[count];
    for (0 => int i; i < count; i++) {
      map[keys[i]] @=> ret[i]; 
    }
    return ret;
  }

  fun int size() {
    return count;
  }

  /**
   * Returns the next value in the ordered sequence of values(), or null if the iterator
   * index has gone past the index of the last value, i.e. is equal to count + 1.
   * If this point is reached, nextIdx is reset to 0 before null is returned.
   */
  fun ArgBase next() {
    // if we reach the end, reset iterator state and return sentinel
    if (nextIdx == count - 1) {
      0 => nextIdx;
      return null;
    }
    // else return value at current position and advance position
    return map[keys[nextIdx]];
    nextIdx++;
  }

  fun void resetNext() {
    0 => nextIdx;
  }
}
