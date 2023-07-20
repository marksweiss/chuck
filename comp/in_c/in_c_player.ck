// Machine.add("lib/comp/player_base.ck")

public class InCPlayer extends PlayerBase {
  string name;
  Sequences seqs;

  // Player must repeat each phrase a minimum number of times
  1 => int MIN_TIMES_REPEAT_PHRASE;
  0 => int phrasePlayCount;

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
    /* 0 => int phraseCount; */
    0 => int loopCount;

    // index of chord in sequence to play
    0 => int i;
    // state triggering time elapsed is == to the duration of previous note played,
    // time to play the next one
    0::samp => dur sinceLastNote;
    this.seqs.current() @=> Sequence seq;
    seq.current() @=> Chord chrd;
    while (true) {

      // TEMP DEBUG
      loopCount++;
      if (name == "sinosc player0") {
        /* if (loopCount % 50 == 0) { */
          <<< "name", name, "TOP OF LOOP, seq.idx", seq.idx >>>;
        /* } */
      }

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

        // TEMP DEBUG
        /* <<< "name", name, "phrasePlayCount > MIN", phrasePlayCount > MIN_TIMES_REPEAT_PHRASE >>>; */

        /* corController.signalRandom(); */
        if (phrasePlayCount > MIN_TIMES_REPEAT_PHRASE && conductor.hasAdvanced(me.id())) {

          // TEMP DEBUG
          if (name == "sinosc player0") {
            <<< "name", name, "GETTING NEXT PHRASE" >>>;
          }

          seqs.next() @=> seq;          

          // TEMP DEBUG
          /* <<< "name", name, "phrase idx", seqs.idx >>>; */

          0 => phrasePlayCount;

          // TEMP DEBUG
          /* phraseCount++; */
          /* <<< "name", name, "phrasePlayCount reset", phrasePlayCount >>>; */
        }
        // /Conductor update current phrase or advanced to next phrase

        // TEMP DEBUG
        if (name == "sinosc player0") {
          <<< "name", name, "phrase chord idx BEFORE, seq.idx", seq.idx >>>;
        }

        // determine whether the next note is the next note in this sequence, or the
        // first note in this sequence (because we are looping and reached the end)
        seq.next() @=> chrd;

        // TEMP DEBUG
        if (name == "sinosc player0") {
          <<< "name", name, "phrase chord idx AFTER NEXT, seq.idx", seq.idx , "chrd", chrd >>>;
        }

        if (chrd == null) {
          phrasePlayCount++;

          // TEMP DEBUG
          /* <<< "name", name, "phrasePlayCount incremented", phrasePlayCount >>>; */
          <<< "name", name, "phrase chord idx BEFORE RESET", seq.idx >>>;

          // reset this sequence to its 0th position for next usage as we loop through sequences
          seq.reset();

          // TEMP DEBUG
          <<< "name", name, "phrase chord idx AFTER RESET", seq.idx >>>;

          seq.next() @=> chrd;

          // assert that the sequence isn't empty so that resetting and taking first note is valid
          if (chrd == null) {
            <<< "ERROR: sequence should return a non-null note after calling reset(), player", name >>>;
            me.exit();
          }
        }

        // TEMP DEBUG
        if (name == "sinosc player0") {
          <<< "name", name, "phrase chord idx AFTER, seq.idx", seq.idx >>>;
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

        // TEMP DEBUG
        if (name == "sinosc player0") {
          <<< "name", name, "phrase chord idx BOTTOM OF LOOP, seq.idx", seq.idx >>>;
        }
      } 
    }
  }

  fun float getGain() {
    return this.gain;
  }

  fun void setGain(float gain) {
    gain => this.gain;
  }

  fun int getPhrasePlayCount() {
    return phrasePlayCount;
  }
}
