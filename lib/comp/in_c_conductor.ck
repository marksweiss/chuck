// Machine.add("lib/collection/set.ck"); 
// Machine.add("lib/comp/conductor.ck"); 

public class InCConductor extends Conductor {
  OrderedStringSet behaviorKeys; 

  "IS_ADVANCING" => string KEY_IS_ADVANCING;
  behaviorKeys.put(KEY_IS_ADVANCING);
  // assumes range [0, 100), i.e. this advances 15% of the time
  85 => int IS_ADVANCING_THRESHOLD;

  // Override
  fun void update(int shredId) {
    isAdvancing(shredId);
  }

  // Override
  fun void updateAll() {
    for (0 => int i; i < this.shredSize(); i++) {
      isAdvancing(this.shredIds[i]);
    }
  }

  // Override
  fun int getBoolBehavior(int shredId, string behaviorKey) {
    if (behaviorKeys.hasKey(behaviorKey)) {
      return this.get(shredId, behaviorKey).intVal;
    }
  }

  fun /*private*/ void isAdvancing(int shredId) {
    if (exceedsThreshold(IS_ADVANCING_THRESHOLD)) {
      this.put(shredId, KEY_IS_ADVANCING, true); 
    } else {
      this.put(shredId, KEY_IS_ADVANCING, false); 
    }
  }
}
