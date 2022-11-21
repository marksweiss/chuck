// Machine.add("lib/copm/conductor.ck"); 

public class InCConductor extends Conductor {
  "IS_ADVANCING" => string KEY_IS_ADVANCING;
  [KEY_IS_ADVANCING] @=> string behaviorKeys[]; 

  // Override
  fun void update(int shredId) {
    isAdvancing(shredId);
  }

  // Override
  fun void updateAll() {
    for (0 => int i; i < this.shredSize(); i++) {
      <<< "i", i, "shredIds.size()", shredIds.size(), "shredSize", shredSize(), "this.shredIds[i]", this.shredIds[i] >>>;

      isAdvancing(this.shredIds[i]);
    }
  }

  // Override
  fun int getBoolBehavior(int shredId, string behaviorKey) {
    if (behaviorKeys.find(behaviorKey) == 1) {
      return this.get(shredId, behaviorKey).intVal;
    }
  }

  fun /*private*/ void isAdvancing(int shredId) {
    // initial policy is just randomly put each shred's next state to true/false
    if (Math.random2(0, 100) > 15) {
      this.put(shredId, KEY_IS_ADVANCING, true); 
    } else {
      this.put(shredId, KEY_IS_ADVANCING, false); 
    }
  }
}
