// Machine.add("lib/comp/instrument/instrument_base/.ck");
// Machine.add("lib/collection/map.ck");

public class PlayerBase {

  OrderedObjectMap instruments; 

  // override
  fun void play() {
    <<< "ERROR: play() must be implemented by derived Player classes" >>>;
    me.exit();
  }

  fun void addInstrument(string key, InstrumentBase instrument) {
    instruments.put(key, instrument);
  }

  fun InstrumentBase getInstrument(string key) {
    return instruments.get(key);
  }
}
