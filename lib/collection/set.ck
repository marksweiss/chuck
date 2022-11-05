// Machine.add("lib/collection/object_map.ck")

public class OrderedStringSet {
  map OrderedObjectMap;

  fun void put(string key) {
    map.put(key, null);
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
    return map.next();
  }

  fun void resetNext() {
    map.resetNext();
  }
}
