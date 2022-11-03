/**
 * Stores key/values with Map semantics. Keys are strings and values are Objects.
 * The data structure also stores key/values in the order keys are originally added,
 * which is stable even if put() is later called on a previously added key; in that
 * case the key retains its position but the associated value is replaced.
 */
// TODO TEST
public class OrderedObjectMap {
  128 => int MAX_NUM_KEYS;
  string keys[MAX_NUM_KEYS];
  Object  map[1];
  0 => int count;

  // iterator support
  0 => int nextIdx;
  // sentinel value for next(), expect user to loop and check
  // Supports client syntax: while (map.next(i) != OrderedMap.END) {...}
  -1 => static int END;

  fun void put(string key, Object val) {
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

  fun Object get(string key) {
    return map[key];
  }

  fun int hasKey(string key) {
    return map.find(key) == 1;
  }

  fun void delete(string key) {
    map.erase(key);
  }

  fun void reset() {
    // clear() instead of reset() because reset() resizes storage to 8 elements
    keys.clear();
    map.clear();
  }

  fun string[] getKeys() {
    return keys;
  }

  fun Object[] getValues() {
    Object ret[count];
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
  fun Object next() {
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

