// TODO TEST
public class OrderedStringSet {
  map OrderedMap;
  -1 => static int DUMMY_VALUE;

  fun void put(string key) {
    map.put(key, DUMMY_VALUE);
  }

  fun int hasKey(string key) {
    return map.hasKey(key);
  }

  fun void delete(string key) {
    map.delete(key);
  }

  fun string[] keys() {
    return map.keys();
  }

  fun int size() {
    return map.size();
  }

  fun ArgBase next() {
    // if we reach the end, reset iterator state and return sentinel
    if (nextIdx == count - 1) {
      0 => nextIdx;
      return END;
    }
    // else return key at current position and advance position
    return map.keys[nextIdx];
    nextIdx++;
  }

  fun void resetNext() {
    map.resetNext();
  }
}
