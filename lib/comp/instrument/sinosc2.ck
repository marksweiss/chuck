// Machine.add("lib/comp/instrument/instrument_base.ck");
// Machine.add("test/assert.ck");

/**
 * SinOsc wrapper, with envelope, adjustable global gain and multiple effects,
 * configurable from CLI args or programmatic call to init(). Supports up to 5
 * polyphonic gens, and so can play chords of up to 5 notes.
 */ 
public class InstrSinOsc2 extends InstrumentBase {
  string name;
  1 => int NUM_GENS;
  // TODO - DO WE NEED THIS?

  // Store conf because this also defines the attrs we can modify
  // TODO these should probably be independent, so we could define a separate ArgParser
  ArgParser conf;

  Gain g;
  // generators
  SinOsc so1;
  /* SinOsc so2; */
  /* SinOsc so3; */
  /* SinOsc so4; */
  /* SinOsc so5; */
  /* [so1, so2, so3, so4, so5] @=> SinOsc gens[]; */
  [so1] @=> SinOsc gens[];
  // envelope
  ADSR env;
  // effects
  // chorus
  Chorus chorus; // .modFreq, .modDepth, .mix
  Modulate modulate;  // .vibratoRate, .vibratoGain, .randomGain
  // delay
  DelayL delay;  // .delay, .max
  Echo echo;  // .delay, .max, .mix
  // reverb
  PRCRev rev; // .mix
  // mix
  Pan2 pan;  // -1 to 1 // .pan
  Mix2 mix;  // stereo to mono mixdown  // .pan

  fun void init(string name, ArgParser conf) {
    name => this.name;
    NUM_GENS => genCount;
    conf @=> this.conf;

    // init all ugens to passthru initially, only set ugens with conf arguments to be sum inputs
    env.op(OP_PASSTHRU);
    chorus.op(OP_PASSTHRU);
    modulate.op(OP_PASSTHRU);
    delay.op(OP_PASSTHRU);
    echo.op(OP_PASSTHRU);
    rev.op(OP_PASSTHRU);
    pan.op(OP_PASSTHRU);
    mix.op(OP_PASSTHRU);

    // args
    if (conf.hasArg("--adsr-attack")) {conf.args["--adsr-attack"].durVal => env.attackTime;}
    if (conf.hasArg("--adsr-decay")) {conf.args["--adsr-decay"].durVal => env.decayTime;}
    if (conf.hasArg("--adsr-sustain")) {conf.args["--adsr-sustain"].fltVal => env.sustainLevel;}
    if (conf.hasArg("--adsr-release")) {conf.args["--adsr-release"].durVal => env.releaseTime;}
    if (conf.hasAnyArg("--adsr")) {
      env.op(OP_SUM);
    }
    // chorus
    if (conf.hasArg("--chorus-mod-freq")) {conf.args["--chorus-mod-freq"].fltVal => chorus.modFreq;}
    if (conf.hasArg("--chorus-mod-depth")) {conf.args["--chorus-mod-depth"].fltVal => chorus.modDepth;}
    if (conf.hasArg("--chorus-mix")) {conf.args["--chorus-mix"].fltVal => chorus.mix;}
    if (conf.hasAnyArg("--chorus")) {
      chorus.op(OP_SUM);
    }
    // modulate
    if (conf.hasArg("--modulate-vibrato-rate")) {conf.args["--modulate-vibrato-rate"].fltVal => modulate.vibratoRate;}
    if (conf.hasArg("--modulate-vibrato-gain")) {conf.args["--modulate-vibrato-gain"].fltVal => modulate.vibratoGain;}
    if (conf.hasArg("--modulate-random-gain")) {conf.args["--modulate-random-gain"].fltVal => modulate.randomGain;}
    if (conf.hasAnyArg("--modulate")) {
      modulate.op(OP_SUM);
    }
    // delay
    if (conf.hasArg("--delay-delay")) {conf.args["--delay-delay"].durVal => delay.delay;}
    if (conf.hasArg("--delay-max")) {conf.args["--delay-max"].durVal => delay.max;}
    if (conf.hasAnyArg("--delay")) {
      delay.op(OP_SUM);
    }
    // echo
    if (conf.hasArg("--echo-delay")) {conf.args["--echo-delay"].durVal => echo.delay;}
    if (conf.hasArg("--echo-max")) {conf.args["--echo-max"].durVal => echo.max;}
    if (conf.hasArg("--echo-mix")) {conf.args["--echo-mix"].fltVal => echo.mix;}
    if (conf.hasAnyArg("--echo")) {
      echo.op(OP_SUM);
    }
    // rev
    if (conf.hasArg("--reverb-mix")) {conf.args["--reverb-mix"].fltVal => rev.mix;}
    if (conf.hasAnyArg("--reverb")) {
      rev.op(OP_SUM);
    }
    // pan
    if (conf.hasArg("--pan-pan")) {
      conf.args["--pan-pan"].fltVal => float panPanVal;
      // TODO UNIT TEST AND FIX
      /* Assert.validate(panPanVal, -1.0, 1.0); */
      panPanVal => pan.pan;
    }
    if (conf.hasAnyArg("--pan")) {
      pan.op(OP_SUM);
    }
    // mix
    if (conf.hasArg("--mix-pan")) {
      conf.args["--mix-pan"].fltVal => float mixPanVal;
      // TODO UNIT TEST AND FIX
      /* Assert.validate(mixPanVal, 0.0, 1.0); */
      mixPanVal => mix.pan;
    }
    if (conf.hasAnyArg("--mix")) {
      pan.op(OP_SUM);
    }
    
    // TODO LOOK AT CHUCK GROUPS FROM CHUCK BOOK
    // create patch chain
    // always precede dac with Gain, because Gain goes out of scope when code stops running,
    // breaking Ugen connection to dac output, but dac does not without explicit use of =< operator.
    // See: https://learning.oreilly.com/library/view/programming-for-musicians/9781617291708/OEBPS/Text/kindle_split_018.html 
    /* so => env => echo => chorus => modulate => delay => rev => env => pan => dac; */
    0.05 => g.gain;
    /* chorus => modulate => delay => rev => pan => env => g => dac; */
    /* chorus => echo => delay => rev => pan => env => g => dac; */
    /* so1 => chorus; */
    /* so2 => chorus; */
    /* so3 => delay; */
    /* so4 => delay; */
    /* so5 => delay; */
  }

  // Override
  // global gain 
  fun Gain getGain() {
    return g;
  }

  // Override
  fun void setGain(int genIdx, float gainVal) {
    gainVal => gens[genIdx].gain;
  }

  // Override
  fun void setGain(float gainVal) {
    for (0 => int i; i < genCount; i++) {
      setGain(i, gainVal);
    } 
  }

  // Override
  // global envelope
  fun ADSR getEnv() {
    return env;
  }

  // Override
  fun UGen getGen(int genIdx) {
    return so1;
    /* return gens[genIdx]; */
  }

  // Override
  /* fun UGen[] getGens() { */
  /*   return gens; */
  /* } */

  // Override
  // global attribute applied to or set up when patches are wired to apply to all gens
  fun void setAttr(string attrName, float attrVal) {
    if (attrName  == "freq") {
      for (0 => int i; i < genCount; i++) {
        attrVal => gens[i].freq; 
      }
    }
    if (attrName  == "modFreq") {
      attrVal => chorus.modFreq;
    }
    if (attrName  == "modDepth") {
      attrVal => chorus.modDepth;
    }
    if (attrName  == "chorusMix") {
      attrVal => chorus.mix;
    }
    if (attrName  == "echoMix") {
      attrVal => rev.mix;
    }
    if (attrName  == "reverbMix") {
      attrVal => echo.mix;
    }
    if (attrName  == "vibratoRate") {
      attrVal => modulate.vibratoRate;
    }
    if (attrName  == "vibratoGain") {
      attrVal => modulate.vibratoGain;
    }
    if (attrName  == "randomGain") {
      attrVal => modulate.randomGain;
    }

    if (attrName  == "mixPan") {
      attrVal => mix.pan;
    }
  } 

  // Override
  fun void setAttr(string attrName, dur attrVal) {
    if (attrName  == "delayDelay") {
      attrVal => delay.delay;
    }
    if (attrName  == "delayMax") {
      attrVal => delay.max;
    }
    if (attrName  == "echoDelay") {
      attrVal => echo.delay;
    }
    if (attrName  == "echoMax") {
      attrVal => echo.max;
    }
  } 

  // Override
  // TODO
  fun void instrHelp() {
    <<< "Args:" >>>;
  }
}
