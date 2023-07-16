/**
 * SinOsc wrapper, with envelope, adjustable global gain and multiple effects,
 * configurable from CLI args or programmatic call to init(). Supports up to 5
 * polyphonic gens, and so can play chords of up to 5 notes.
 */ 
public class InstrSinOsc extends InstrumentEffectsBase {
  string name;

  SinOsc so;
  Gain g;
  ArgParser conf;

  fun void init(string name, float phase, ArgParser conf) {
    1 => genCount;

    name => this.name;
    phase => so.phase;
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
    return so;
  }

  // Override
  fun UGen[] getGens() {
    return [so];
  }

  // Override
  // global attribute applied to or set up when patches are wired to apply to all gens
  fun void setAttr(string attrName, float attrVal) {
    if (attrName  == "freq") {
      attrVal => so.freq; 
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
