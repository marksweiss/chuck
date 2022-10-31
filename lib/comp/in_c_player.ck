// Machine.add("lib/comp/player_base.ck")


public class InCPlayer extends PlayerBase {
  string name;
  Sequences seqs;
  // events, boilerplate but must be assigned by reference per instance because they are bound
  // to a particular spork and possibly spawned by one or another parent event loop
  Event startEvent;
  Event stepEvent;
  dur stepDur;
  Conductor conductor;

  fun void init(string name, Sequences seqs, Event startEvent, Event stepEvent, dur stepDur,
                Conductor conductor) {
    name => this.name;
    seqs @=> this.seqs;
    startEvent @=> this.startEvent;    
    stepEvent @=> this.stepEvent;    
    stepDur => this.stepDur;
    conductor @=> this.conductor;
  }

  // override
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

          // TODO UPDATE comp_sinosc_2.ck to use this class
        
          // TODO HOW TO SUPPORT ARBITRARY INSTRUMENTS BEING CHANGED IN ARBITRARY WAYS
          // BASED ON THE INSTRUMENT AND THE COMPOSITION
          /* n.gain => so.gain; */
        }

        // Advance sequence iterator to next chord in sequence 
        // Sequences are in isLooping mode so we just keep rolling over each sequence
        // but using hasNext iterator API for each sequence, so either we can move to its
        // next note or we have to advance to the next sequence in sequences
        if (!seq.hasNext()) {
          // if the Conductor state for this shred is to advance, otherwise stay on this phrase
          conductor.update(me.id());

          // composition-specific conductor state update calls
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
}
