// Machine.add("lib/comp/player_base.ck")


public class InCPlayer extends PlayerBase {
  string name;
  Sequences seqs;
  // events, boilerplate but must be assigned by reference per instance because they are bound
  // to a particular spork and possibly spawned by one or another parent event loop
  Event startEvent;
  Event stepEvent;
  dur stepDur;
  InCConductor conductor;
  InstrumentBase instr;

  fun void init(string name, Sequences seqs, Event startEvent, Event stepEvent, dur stepDur,
                InCConductor conductor, InstrumentBase instr) {
    name => this.name;
    seqs @=> this.seqs;
    startEvent @=> this.startEvent;    
    stepEvent @=> this.stepEvent;    
    stepDur => this.stepDur;
    conductor @=> this.conductor;
    instr @=> this.instr;

    <<< "PLAYER INIT DONE" >>>;
  }

  // override
  fun void play() {
    <<< "IN PLAYER PLAY BEFORE START EVENT RECEIVED, shred id:", me.id() >>>;

    // block on START
    startEvent => now;

    // index of chord in sequence to play
    0 => int i;
    // state triggering time elapsed is == to the duration of previous note played,
    // time to play the next one
    0::samp => dur sinceLastNote;
    this.seqs.current() @=> Sequence seq;
    seq.current() @=> Chord c;
    while (true) {
      // block on event of next beat step broadcast by clock
      stepEvent => now;

      // NOTE: assumes all notes in current chord are same duration

      /* <<< "IN PLAYER WHILE LOOP BEFORE c.notes[0]" >>>; */

      c.notes[0].duration => dur nextNoteDur;

      /* stepDur => now; */

      /* <<< "AFTER STEP_DUR" >>>; */

      sinceLastNote + stepDur => sinceLastNote; 

      /* <<< "name", name, "sinceLastNote", sinceLastNote, "nextNoteDur", nextNoteDur >>>; */

      // if enough time has passed, emit the next note, silence the previous note
      if (sinceLastNote == nextNoteDur) {
        // previous note ending, trigger release
        instr.getEnv().keyOff();
        instr.getEnv().releaseTime() => now;

        // load the next chord into all the gens in the instrument
        for (0 => int j; j < c.notes.size(); j++) {
          c.notes[j] @=> Note n;
          instr.setAttr("freq", Std.mtof(n.pitch));

          /* <<< "INSTR name", this.name, "pitch", n.pitch >>>; */

          instr.getGain() @=> Gain g;
          n.gain => g.gain;
        }

        seq.next() @=> c;
        if (c == null) {

          <<< "IN PLAYER WHILE LOOP AFTER SEQ.NEXT() == NULL", me.id() >>>;

          // reset this sequence to its 0th position for next usage as we loop through sequences
          seq.reset();

          // check Conductor state to determine whether to advance or stay on this phrase
          conductor.update(me.id());
          if (conductor.getBoolBehavior(me.id(), conductor.KEY_IS_ADVANCING)) {
            this.seqs.next() @=> seq;
          }

          seq.next() @=> c;
        }

        // reset note triggering state
        0::samp => sinceLastNote;
        // trigger envelope start
        instr.getEnv().keyOn();
      }

      /* <<< "IN PLAYER BEFORE SIGNAL, id", me.id() >>>; */

      /* stepEvent => now; */
      /* stepEvent.signal(); */
      /* me.exit(); */

      <<< "IN PLAYER AFTER SIGNAL, id", me.id() >>>;
    }
  }
}
