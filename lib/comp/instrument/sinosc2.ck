// Machine.add("lib/comp/scale.ck");
// Machine.add("lib/comp/note.ck");
// Machine.add("lib/comp/chord.ck");
// Machine.add("lib/comp/clock.ck");
// Machine.add("lib/comp/instrument/instrument_base.ck");

/**
 * SinOsc wrapper, with envelope, adjustable global gain and multiple effects,
 * configurable from CLI args or programmatic call to init()
 */ 
public class InstrSinOsc2 extends InstrumentBase {
  // generator
  SinOsc so;
  // envelope
  ADSR env;

  // effects
  Chorus chorus; // .modFreq, .modDepth, .mix
  Modulate modulate;  // .vibratoRate, .vibratoGain, .randomGain
  // delay
  DelayL delay;  // .delay, .max
  Echo echo;  // .delay, .max, .mix
  // reverb
  PRCRev rev; // .mix
  // mix
  Pan2 pan;  // -1 to 1 // .pan
  Mix2 mix  // stereo to mono mixdown  // .pan

  // patch chain
  so => env => chorus => modulate => delay => echo => rev => pan => mix => dac;

  // events, boilerplate but must be assigned by reference per instance because they are bound
  // to a particular spork and possibly spawned by one or another parent event loop
  Event startEvent;
  Event stepEvent;
  dur stepDur;

  fun void init(ArgParser conf, Event startEvent, Event stepEvent, dur stepDur) {
    // args
    // env
    conf.args[adsrAttack.nameToFlag()].durVal => dur adsrAttack;
    conf.args[adsrDecay.nameToFlag()].durVal => dur adsrDecay;
    conf.args[adsrSustain.nameToFlag()].fltVal => dur adsrSustain;
    conf.args[adsrRelease.nameToFlag()].durVal => dur adsrRelease;
    env.set(adsrAttack, adsrDecay, adsrSustain, adsrRelease);
    // chorus
    conf.args[chorusModFreq.nameToFlag()].fltVal => chorus.modFreq;
    conf.args[chorusModDepth.nameToFlag()].fltVal => chorus.modDepth;
    conf.args[chorusMix.nameToFlag()].fltVal => float chorus.mix;
    // modulate
    conf.args[modulateVibrationRate.nameToFlag()].fltVal => modulate.vibrationRate;
    conf.args[modulateVibrationGain.nameToFlag()].fltVal => modulate.vibrationGain;
    conf.args[modulateRandomGain.nameToFlag()].fltVal => float modulate.randomGain;
    // delay
    conf.args[delayDelay.nameToFlag()].durVal => delay.delay;
    conf.args[delayMax.nameToFlag()].durVal => delay.max;
    // echo
    conf.args[echoDelay.nameToFlag()].durVal => echo.delay;
    conf.args[echoMax.nameToFlag()].durVal => echo.max;
    conf.args[echoMin.nameToFlag()].durVal => echo.min;
    // rev
    conf.args[reverbMix.nameToFlag()].fltVal => float rev.mix;
    // pan
    // validate -1 to 1
    panPan.nameToFlag()].fltVal => float panPanVal;
    Assert.validate(panPanVal, -1.0, 1.0);
    panPanVal => pan.pan;
    // mix
    // validate 0 to 1
    mixPan.nameToFlag()].fltVal => float mixPanVal;
    Assert.validate(mixPanVal, 0.0, 1.0);
    mixPanVal => mix.pan;
    
    // boilerplate event assignment
    startEvent @=> this.startEvent;    
    stepEvent @=> this.stepEvent;    
    stepDur => this.stepDur;
  }

  // TODO
  fun void instrHelp() {
    <<< "Args:" >>>;
  }

  fun void play() {
    // block on START
    startEvent => now;

    // index of chord in sequence to play
    0 => int i;
    // state triggering time elapsed is == to the duration of previous note played,
    // time to play the next one
    0::samp => dur sinceLastNote;
    while (true) {
      // get next chord  to play
      chords[i] @=> Chord c;
      c.notes[0].duration => dur nextNoteDur;

      // block on event of next beat step broadcast by clock
      stepEvent => now;
      sinceLastNote + stepDur => sinceLastNote; 
      // if enough time has passed, emit the next note, silence the previous note
      if (sinceLastNote == nextNoteDur) {
        Scale s;
        
        // previous note ending, trigger release
        env.keyOff();
        env.releaseTime() => now;

        // ANY OTHER DYNAMIC PER-NOTE EFFECTS CONFIGURATION HERE

        // load the next note into the gen
        for (0 => int j; j < c.notes.size(); j++) {
          c.notes[j] @=> Note n;
          // TODO float freq support
          so.freq(Std.mtof(n.pitch)); 
          n.gain => so.gain;
        }

        // reset note triggering state
        0::samp => sinceLastNote;
        // increment counter of which chord in sequence
        (i + 1) % numChords => i;

        // trigger envelope start
        // default envelope behavior to avoid clipping
        env.set(10::ms, 2::ms, 0.8, 10::ms);
        env.keyOn();

        // note emitted, yield to clock
        me.yield();
      }
    }
  }
}
