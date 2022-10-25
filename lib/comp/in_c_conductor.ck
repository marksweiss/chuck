// Machine.add("lib/copm/conductor.ck"); 

public class InCConductor extends Conductor {
  "IS_ADVANCING" => string KEY_IS_ADVANCING;

  // Override
  fun void update(int shredId) {
    isAdvancing(shredId);
  }

  fun void updateAll() {
    for (0 => int i; i < this.shredIds.size(); i++) {
      isAdvancing(this.shredIds[i]);
    }
  }

  fun int getIsAdvancing(int shredId) {
    return this.get(shredId, KEY_IS_ADVANCING);
  }

  fun /*private*/ void isAdvancing(int shredId) {
    // initial policy is just randomly put each shred's next state to true/false
    if (Math.random2(0, 100) > 50) {
      this.put(shredId, KEY_IS_ADVANCING, true); 
    } else {
      this.put(shredId, KEY_IS_ADVANCING, false); 
    }
  }
}
