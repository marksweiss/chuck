// Machine.add("lib/comp/scale.ck");
// Machine.add("lib/comp/note.ck");
// Machine.add("lib/comp/chord.ck");
// Machine.add("lib/comp/clock.ck");
// Machine.add("lib/comp/instrument/instrument_base.ck");

/**
 * Basic SinOsc wrapper, adding only default ADSR to avoid clipping
 */ 
public class InstrSinOsc extends InstrumentBase {
  // generator
  SinOsc so;
  // envelope
  // in this basic instrument ADSR is not parameterized and just set to defaults to avoid
  // clipping on transitions from sounding notes to rests and back
  ADSR env;
  // patch chain
  so => env => dac;

  // events, boilerplate but must be assigned by reference per instance because they are bound
  // to a particular spork and possibly spawned by one or another parent event loop
  Event startEvent;
  Event stepEvent;
  dur stepDur;

  fun void init(ArgParser conf, Event startEvent, Event stepEvent, dur stepDur) {
    // ArgParser no-op for this instrument
    // boilerplate event assignment
    startEvent @=> this.startEvent;    
    stepEvent @=> this.stepEvent;    
    stepDur => this.stepDur;
  }

  fun void instrHelp() {
    <<< "No args accepted" >>>;
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
