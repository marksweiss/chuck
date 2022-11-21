// Machine.add("lib/collection/object_map.ck")

public class OrderedStringSet {
  OrderedObjectMap map;

  fun void put(string key) {
    map.put(key, null);
  }

  fun int hasKey(string key) {
    return map.hasKey(key);
  }

  fun void delete(string key) {
    map.delete(key);
  }

  fun string[] getKeys() {
    return map.getKeys();
  }

  fun int size() {
    return map.size();
  }

  fun Object next() {
    return map.next();
  }

  fun void resetNext() {
    map.resetNext();
  }
}
