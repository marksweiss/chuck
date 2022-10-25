// Machine.add("lib/comp/conductor.ck");
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
 * configurable from CLI args or programmatic call to init(). Supports up to 5
 * polyphonic gens, and so can play chords of up to 5 notes.
 */ 
public class InstrSinOsc2 extends InstrumentBase {
  5 => static int MAX_NUM_VOICES;

  // TODO - DO WE NEED THIS?
  Gain g;
  // generators
  SinOsc so1;
  SinOsc so2;
  SinOsc so3;
  SinOsc so4;
  SinOsc so5;
  [so1, so2, so3, so4, so5] @=> SinOsc gens[MAX_NUM_VOICES];
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

  string name;
  Sequences seqs;
  // events, boilerplate but must be assigned by reference per instance because they are bound
  // to a particular spork and possibly spawned by one or another parent event loop
  Event startEvent;
  Event stepEvent;
  dur stepDur;
  Conductor conductor;

  fun void init(string name, ArgParser conf, Sequences seqs,
                Event startEvent, Event stepEvent, dur stepDur, Conductor conductor) {
    name => this.name;
    seqs @=> this.seqs;
    startEvent @=> this.startEvent;    
    stepEvent @=> this.stepEvent;    
    stepDur => this.stepDur;

    conductor @=> this.conductor;

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
    
    // create patch chain
    // always precede dac with Gain, because Gain goes out of scope when code stops running,
    // breaking Ugen connection to dac output, but dac does not without explicit use of =< operator.
    // See: https://learning.oreilly.com/library/view/programming-for-musicians/9781617291708/OEBPS/Text/kindle_split_018.html 
    /* so => env => echo => chorus => modulate => delay => rev => env => pan => dac; */
    0.05 => g.gain;
    delay => rev => pan => env => g => dac;
    so1 => delay;
    so2 => delay;
    so3 => delay;
    so4 => delay;
    so5 => delay;
  }

  // Override
  fun void play() {
    // TEMP DEBUG
    <<< "IN INSTR PLAY BEFORE START EVENT RECEIVED, shred id:", me.id() >>>;

    // block on START
    startEvent => now;

    // index of chord in sequence to play
    0 => int i;
    // state triggering time elapsed is == to the duration of previous note played,
    // time to play the next one
    0::samp => dur sinceLastNote;
    this.seqs.current() @=> Sequence seq;
    while (true) {
      seq.current() @=> Chord c;
      // NOTE: assumes all notes in current chord are same duration
      c.notes[0].duration => dur nextNoteDur;

      // block on event of next beat step broadcast by clock
      stepEvent => now;
      stepDur => now;
      sinceLastNote + stepDur => sinceLastNote; 

      /* <<< "name", this.name, "sinceLastNote", sinceLastNote, "nextNoteDur", nextNoteDur >>>; */

      // if enough time has passed, emit the next note, silence the previous note
      if (sinceLastNote == nextNoteDur) {
        // previous note ending, trigger release
        env.keyOff();
        env.releaseTime() => now;

        // load the next chord into the gen
        for (0 => int j; j < c.notes.size(); j++) {
          c.notes[j] @=> Note n;
          gens[i].freq(Std.mtof(n.pitch)); 

          /* <<< "INSTR name", this.name, "pitch", n.pitch >>>; */

          /* n.gain => so.gain; */
        }

        // Advance sequence iterator to next chord in sequence 
        // Sequences are in isLooping mode so we just keep rolling over each sequence
        // but using hasNext iterator API for each sequence, so either we can move to its
        // next note or we have to advance to the next sequence in sequences
        if (!seq.hasNext()) {
          // if the Conductor state for this shred is to advance, otherwise stay on this phrase
          conductor.update(me.id());
          

          // TODO THIS DESIGN IS BROKEN
          // WE NEED TO PASS CONDUcTOR HERE POLYMORPHICALLY BY BASE CLASS REF
          // BUT WE ALSO NEED TO EITHER KNOW THE KEY NAME OR WRAP THAT IN A DERIVED CLASS GETTER
          // OR WE CAN INHERIT ALL THE INSTRUMENT SETUP BUT DERIVE AGAIN SO THE play() IS SPECIFIC
          // TO EACH COPMOSITION AND SO KNOWS ABOUT DERIVED CONDUCTOR

          if (conductor.getIsAdvancing(me.id())) {
            this.seqs.next() @=> seq;
          }
          // either we advanced and if it is after the first iteration this sequence was used before
          // so reset it, or we stayed on the same sequence and just got to the end so reset it
          seq.reset();
        } else {
          // otherwise advance to next note in current sequence
          seq.next();
        }

        // reset note triggering state
        0::samp => sinceLastNote;
        // trigger envelope start
        env.keyOn();
      }

      me.yield();
    }
  }

  // Override
  // TODO
  fun void instrHelp() {
    <<< "Args:" >>>;
  }
}
