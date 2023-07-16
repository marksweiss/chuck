public class InstrSawOsc extends InstrumentEffectsBase {
  string name;

  SawOsc osc;
  Gain g;
  ArgParser conf;

  fun void init(string name, float phase, float width, ArgParser conf) {
    1 => genCount;

    name => this.name;
    phase => osc.phase;
    width => osc.width;
    0 => osc.sync;
    conf @=> this.conf;

    initEffects(conf);
    
    0.05 => g.gain;
  }

  // Override
  // global gain 
  fun Gain getGain() {
    return g;
  }

  // Override
  fun void setGain(int genIdx, float gainVal) {
    gainVal => g.gain;
  }

  // Override
  fun void setGain(float gainVal) {
    gainVal => g.gain;
  }

  // Override
  fun UGen getGen(int genIdx) {
    return osc;
  }

  // Override
  fun UGen[] getGens() {
    return [osc];
  }

  // Override
  // global attribute applied to or set up when patches are wired to apply to all gens
  fun void setAttr(string attrName, float attrVal) {
    if (attrName  == "freq") {
      attrVal => osc.freq;
    } else if (attrName  == "phase") {
      attrVal => osc.phase; 
    } else if (attrName  == "width") {
      attrVal => osc.width; 
    } else {
      setEffectsAttr(attrName, attrVal);
    }
  } 

  // Override
  fun void setAttr(string attrName, dur attrVal) {
    setEffectsAttr(attrName, attrVal);
  } 

  // Override
  fun void instrHelp() {
    <<< "Args: name: name of the instrument, phase: sin phase, conf: effects config map" >>>;
  }
}
