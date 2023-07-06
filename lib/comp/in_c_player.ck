// Machine.add("lib/comp/player_base.ck")


public class InCPlayer extends PlayerBase {
  string name;
  Sequences seqs;
  int seqsIdx;
  0.5 => float DEFAULT_GAIN;
  // Players store the gain they are currently setting for all notes they play, allows
  // per-Player dynamics to be controlled by Conductor
  DEFAULT_GAIN => float gain;
  // events, boilerplate but must be assigned by reference per instance because they are bound
  // to a particular spork and possibly spawned by one or another parent event loop
  Event startEvent;
  Event stepEvent;
  Event updateEvent;
  Event updateCompleteEvent; // Player signals Clock so Clock can signal next Player to update
  Event playOutputEvent;
  CoroutineController corController;
  dur stepDur;
  InCConductor conductor;
  InstrumentBase instr;

  fun void init(string name, Sequences seqs, Event startEvent, Event stepEvent, // Event updateEvent,
                // Event updateCompleteEvent, Event playOutputEvent,
                CoroutineController corController,
                dur stepDur, InCConductor conductor, InstrumentBase instr) {
    name => this.name;
    seqs @=> this.seqs;
    0 => seqsIdx;
    startEvent @=> this.startEvent;
    stepEvent @=> this.stepEvent;    
    updateEvent @=> this.updateEvent;
    updateCompleteEvent @=> this.updateCompleteEvent;
    playOutputEvent @=> this.playOutputEvent;
    corController @=> this.corController;
    stepDur => this.stepDur;
    conductor @=> this.conductor;
    instr @=> this.instr;
  }

  // TODO REMOVE AND FROM BASE CLASS
  /* Override */
  /* fun void signalUpdate() { */
  /*   updateEvent.signal(); */
  /* } */

  // override
  fun void play() {
    // block on startEvent to all sync start time on clock.sync()
    startEvent => now;

    // set initial state in conductor for this player
    conductor.initPlayer(me.id());

    // index of chord in sequence to play
    0 => int i;
    // state triggering time elapsed is == to the duration of previous note played,
    // time to play the next one
    0::samp => dur sinceLastNote;
    this.seqs.current() @=> Sequence seq;
    seq.current() @=> Chord c;
    while (true) {

      // TEMP DEBUG
      /* <<< "TOP OF PLAYER PLAY() LOOP BEFORE STEP EVENT id ", me.id(), me.running() >>>; */

      // NOTE: assumes all notes in current chord are same duration
      c.notes[0].duration => dur nextNoteDur;
      sinceLastNote + stepDur => sinceLastNote; 

      // TEMP DEBUG
      /* <<< "TOP OF PLAYER PLAY() LOOP AFTER STEP EVENT BEFORE STEP DUR id ", me.id(), "sinceLastNote", sinceLastNote >>>; */

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

      // TEMP DEBUG
      /* <<< "TOP OF PLAYER PLAY() LOOP AFTER STEP DUR id ", me.id(), "sinceLastNote", sinceLastNote >>>; */

      // if enough time has passed, emit the next note, silence the previous note
      if (sinceLastNote == nextNoteDur) {

        // TEMP DEBUG
        <<< "PLAYER BEFORE BLOCK ON UPDATE EVENT", me.id() >>>; 

        // TODO CAN WE GET RID OF THIS EVENT WHICH DOESN'T ACTUALLY WORK TO COORDINATE UPDATE, USE COR
        // BLOCK HERE, ENTER ONE AT A TIME
        /* updateEvent => now; */

        // TEMP DEBUG
        <<< "PLAYER AFTER BLOCK ON UPDATE EVENT", me.id() >>>; 

        // previous note ending, trigger release
        instr.getEnv().keyOff();
        instr.getEnv().releaseTime() => now;

        // TODO CLEAN UP ID SO WE JUST USE ONE KIND and it's the threadId or should it be decoupled from that?
        // Conductor update current phrase or advanced to next phrase
        /* if (!corController.isHead) { */
        /*   corController.pause(); */
        /* } */

        // TEMP DEBUG
        <<< "PLAYER BEFORE DO_UPDATE", "thread", me.id(), "cor id", corController.id  >>>; 

        conductor.doUpdate(me.id(), seq) @=> Sequence seq;

        // TEMP DEBUG
        <<< "PLAYER AFTER DO_UPDATE", "thread", me.id(), "cor id", corController.id  >>>; 

        corController.signalNext();

        // TEMP DEBUG
        <<< "PLAYER AFTER SIGNAL_NEXT", "thread", me.id(), "cor id", corController.id  >>>; 

        /* if (corController.isHead) { */
        /*   corController.pause(); */
        /* } else { */
        /* corController.yield(); */
        /* } */

        if (! conductor.isPlaying()) {
          break;
        }

        if (conductor.hasAdvanced(me.id())) {
          1 +=> seqsIdx;
          seqs.next() @=> seq;          
        }
        // /Conductor update current phrase or advanced to next phrase

        // TEMP DEBUG
        <<< "BEFORE UPDATE COMPLETE EVENT SIGNAL", me.id() >>>;

        // TODO SIGNAL CLOCK HERE THAT UPDATE IS DONE AND CLOCK SHOULD SIGNAL THE NEXT PLAYER TO UPDATE
        /* updateCompleteEvent.signal(); */

        // TEMP DEBUG
        <<< "AFTER UPDATE COMPLETE EVENT SIGNAL BEFORE BLOCK PLAY OUTPUT EVENT", me.id() >>>;

        // TODO CAN WE GET RID OF THIS EVENT WHICH DOESN'T ACTUALLY WORK TO COORDINATE UPDATE, USE COR
        // BLOCK HERE AND THEN UNBLOCK BY CLOCK AND UPDATE LOCAL STATE AND PLAY OUTPUT CONCURRENTLY
        /* playOutputEvent => now; */
  
        // determine whether the next note is the next note in this sequence, or the
        // first note in this sequence (because we are looping and reached the end)
        seq.next() @=> c;
        if (c == null) {
          // reset this sequence to its 0th position for next usage as we loop through sequences
          seq.reset();
          seq.next() @=> c;
          // assert that the sequence isn't empty so that resetting and taking first note is valid
          if (c == null) {
            <<< "ERROR: sequence should return a non-null note after calling reset()" >>>;
            me.exit();
          }
        } 

        // TEMP DEBUG
        <<< "BEFORE SET GAIN notes.size", c.notes.size() >>>;

        // load the next chord into all the gens in the instrument
        for (0 => int j; j < c.notes.size(); j++) {
          c.notes[j] @=> Note n;
          instr.setAttr("freq", Std.mtof(n.pitch));

          // TEMP DEBUG
          <<< "SET GAIN" >>>;

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
