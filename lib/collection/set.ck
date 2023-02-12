// Machine.add("lib/collection/object_map.ck")

public class OrderedStringSet {
  OrderedObjectMap map;

  fun void put(string key) {
    // Must put a non-null value or map.delete() seg faults
    Object o;
    map.put(key, o);
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

  // TODO TEST
  fun int empty() {
    return size() == 0;
  }

  fun int notEmpty() {
    return size() > 0;
  }

  fun Object next() {
    return map.next();
  }

  fun void resetNext() {
    map.resetNext();
  }
}
