// Machine.add("lib/comp/scale.ck");
// Machine.add("lib/comp/note.ck");
// Machine.add("lib/comp/chord.ck");
// Machine.add("lib/comp/sequence.ck");
// Machine.add("lib/comp/sequences.ck");
// Machine.add("lib/comp/clock.ck");
// Machine.add("lib/comp/instrument/instrument_base.ck");
// Machine.add("test/assert.ck");

/**
 * SinOsc wrapper, with envelope, adjustable global gain and multiple effects,
 * configurable from CLI args or programmatic call to init()
 */ 
public class InstrSinOsc2 extends InstrumentBase {
  Sequences seqs;

  // generator
  SinOsc so;
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

  // events, boilerplate but must be assigned by reference per instance because they are bound
  // to a particular spork and possibly spawned by one or another parent event loop
  Event startEvent;
  Event stepEvent;
  dur stepDur;

  fun void init(ArgParser conf, Sequences seqs, Event startEvent, Event stepEvent, dur stepDur) {
    seqs @=> this.seqs;
    startEvent @=> this.startEvent;    
    stepEvent @=> this.stepEvent;    
    stepDur => this.stepDur;

    // init all ugens to passthu initially, only set ugens with conf arguments to be default sum inputs
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
    
    // create patch chain
    so => env => echo => chorus => modulate => delay => rev => env => pan => dac;
  }

  // Override
  fun void play() {
    // block on START
    startEvent => now;

    // index of chord in sequence to play
    0 => int i;
    // state triggering time elapsed is == to the duration of previous note played,
    // time to play the next one
    0::samp => dur sinceLastNote;
    while (true) {
      // get next sequence to play and chord to play from that sequence

      // TODO HANDLE seqs NEXT, RIGHT NOW JUST ONE seq in seqs so always call next()
      /* this.seqs.next() @=> seq; */
      this.seqs.next() @=> Sequence seq;

      seq.next() @=> Chord c;
      c.notes[0].duration => dur nextNoteDur;

      // block on event of next beat step broadcast by clock
      stepEvent => now;
      sinceLastNote + stepDur => sinceLastNote; 

      // if enough time has passed, emit the next note, silence the previous note
      if (sinceLastNote == nextNoteDur) {
        // previous note ending, trigger release
        env.keyOff();
        env.releaseTime() => now;

        // ANY OTHER DYNAMIC PER-NOTE EFFECTS CONFIGURATION HERE

        // load the next note into the gen
        for (0 => int j; j < c.notes.size(); j++) {
          c.notes[j] @=> Note n;
          so.freq(Std.mtof(n.pitch)); 
          n.gain => so.gain;
        }

        // reset note triggering state
        0::samp => sinceLastNote;

        // TODO HANDLE seqs increment and NEXT

        // increment counter of which chord in sequence
        (i + 1) % seq.size() => i;

        // trigger envelope start
        env.keyOn();
        // note emitted, yield to clock
        me.yield();
      }
    }
  }

  // Override
  fun void setOp(int op) {
    so.op(op);
  }

  // Override
  // TODO
  fun void instrHelp() {
    <<< "Args:" >>>;
  }

}
