// Machine.add("lib/comp/player_base.ck")

public class InCPlayer extends PlayerBase {
  string name;
  Sequences seqs;
  0.5 => float DEFAULT_GAIN;
  // Players store the gain they are currently setting for all notes they play, allows
  // per-Player dynamics to be controlled by Conductor
  DEFAULT_GAIN => float gain;
  // events, boilerplate but must be assigned by reference per instance because they are bound
  // to a particular spork and possibly spawned by one or another parent event loop
  Event startEvent;
  Event stepEvent;
  CoroutineController corController;
  dur stepDur;
  InCConductor conductor;
  InstrumentBase instr;

  fun void init(string name, Sequences seqs, Event startEvent, Event stepEvent,
                CoroutineController corController, dur stepDur, InCConductor conductor,
                InstrumentBase instr) {
    name => this.name;
    seqs @=> this.seqs;
    startEvent @=> this.startEvent;
    stepEvent @=> this.stepEvent;    
    corController @=> this.corController;
    stepDur => this.stepDur;
    conductor @=> this.conductor;
    instr @=> this.instr;
  }

  // override
  fun void play() {
    // block on startEvent to all sync start time on clock.sync()
    startEvent => now;

    /* corController.signalRandom(); */
    // set initial state in conductor for this player
    conductor.initPlayer(me.id());

    // TEMP DEBUG
    0 => int phraseCount;

    // index of chord in sequence to play
    0 => int i;
    // state triggering time elapsed is == to the duration of previous note played,
    // time to play the next one
    0::samp => dur sinceLastNote;
    this.seqs.current() @=> Sequence seq;
    seq.current() @=> Chord chrd;
    while (true) {
      // NOTE: assumes all notes in current chord are same duration
      chrd.notes[0].duration => dur nextNoteDur;
      sinceLastNote + stepDur => sinceLastNote; 

      // Block on event of next beat step broadcast by clock. Each player blocks until
      // the clock advances global `now` one tempo duration and then broadcasts on this
      // Event. Then each player wakes up, adds the duration of the current note being
      // played to a running total and, if global time since the note started playing
      // has advanced to equal the duration of that note, stops playing that note
      // and gets the next note to play. The next note is either the next note in the
      // current sequence, or, if the player just played the last note in the current
      // sequence, it is is the first note in the same sequence (if not advancing
      // to the next sequence) or the first note in the next sequence (if advancing).
      stepEvent => now;

      // if enough time has passed, emit the next note, silence the previous note
      if (sinceLastNote >= nextNoteDur) {
        // previous note ending, trigger release
        instr.getEnv().keyOff();
        instr.getEnv().releaseTime() => now;

        corController.signalRandom();
        conductor.doUpdate(me.id(), seq) @=> Sequence seq;

        /* corController.signalRandom(); */
        if (! conductor.isPlaying()) {
          break;
        }

        /* corController.signalRandom(); */
        if (conductor.hasAdvanced(me.id())) {
          seqs.next() @=> seq;          

          // TEMP DEBUG
          phraseCount++;
        }
        // /Conductor update current phrase or advanced to next phrase

        // determine whether the next note is the next note in this sequence, or the
        // first note in this sequence (because we are looping and reached the end)
        seq.next() @=> chrd;
        if (chrd == null) {
          // reset this sequence to its 0th position for next usage as we loop through sequences
          seq.reset();
          seq.next() @=> chrd;

          // assert that the sequence isn't empty so that resetting and taking first note is valid
          if (chrd == null) {

            // TEMP DEBUG
            <<< "phraseCount", phraseCount, "seq size", seq.size(), "seq index", seq.idx, "seq isLooping", seq.isLooping >>>;

            <<< "ERROR: sequence should return a non-null note after calling reset(), player", name >>>;
            me.exit();
          }
        }

        // load the next chord into all the gens in the instrument
        for (0 => int j; j < chrd.notes.size(); j++) {
          chrd.notes[j] @=> Note n;
          instr.setAttr("freq", Std.mtof(n.pitch));
          instr.setGain(this.gain);
        }

        // reset note triggering state
        0::samp => sinceLastNote;

        // trigger envelope start
        instr.getEnv().keyOn();
      } 
    }
  }

  fun float getGain() {
    return this.gain;
  }

  fun void setGain(float gain) {
    gain => this.gain;
  }
}
