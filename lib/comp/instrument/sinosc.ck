// Machine.add("lib/comp/scale.ck");
// Machine.add("lib/comp/note.ck");
// Machine.add("lib/comp/chord.ck");
// Machine.add("lib/comp/clock.ck");
// Machine.add("lib/comp/instrument/instrument.ck");

public class InstrSinOsc extends Instrument {
  // ugen setup
  Gain g;
  SinOsc so => g => dac;
  // args specific to this instr
  "--gain" => string ARG_GAIN;
  // events
  Event startEvent;
  Event stepEvent;
  dur stepDur;

  fun void init(ArgParser conf, Event startEvent, Event stepEvent, dur stepDur) {
    startEvent @=> this.startEvent;    
    stepEvent @=> this.stepEvent;    
    stepDur => this.stepDur;
  }

  fun void instrHelp() {
    <<< "Args:\n'gain' - float - [0.0..1.0]" >>>;
  }

  fun void play() {
    // block on START
    startEvent => now;

    0 => int i;
    0::samp => dur sinceLastNote;
    while (true) {
      // get next note to play
      chords[i] @=> Chord c;

      /* <<< "IN INSTR TOP OF LOOP on chord index:", i, "Chord", c >>>; */

      c.notes[0].duration => dur nextNoteDur;

      // block on event of next beat step broadcast by clock
      stepEvent => now;
      sinceLastNote + stepDur => sinceLastNote; 

      /* <<< "IN INSTR BEFORE Note dur equaled, now:", now, "sinceLastNote:", sinceLastNote, "nextNoteDur:", nextNoteDur >>>; */

      // if enough time has passed, emit the next note, silence the previous note
      if (sinceLastNote == nextNoteDur) {

        /* <<< "IN INSTR Note dur equaled, sinceLastNote:", sinceLastNote, "nextNoteDur:", nextNoteDur >>>; */
        Scale s;

        for (0 => int j; j < c.notes.cap(); j++) {
          c.notes[j] @=> Note n;
          
          /* <<< "IN INSTR note gain", n.gain >>>; */ 
          /* <<< "IN INSTR NOTE BEING ADDED name:", n.name, "pitch:", s.pitchName(n.pitch) >>>; */

          // TODO float freq support
          so.freq(Std.mtof(n.pitch)); 
          n.gain => g.gain;

          /* <<< "IN INSTR NOTE EMITTED, g.gain", g.gain(), "note dur", n.duration, now >>>; */
        }

        0::samp => sinceLastNote;
        (i + 1) % numChords => i;

        /* <<< "IN INSTR on chord index:", i >>>; */

        me.yield();
      }
    }
  }
}
