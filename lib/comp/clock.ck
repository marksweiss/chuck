// Machine.add("lib/util/util.ck")
// Machine.add("lib/comp/instrument.ck")
// Machine.add("lib/comp/conductor.ck")

// Based on https://chuck.stanford.edu/doc/learn/notes/tg.ck
// name: tg.ck
// desc: TimeGrid class; basic timing operations abbreviated
// author: Graham Coleman 

public class Clock {
  4 => static float QUARTER_NOTE; 
  64 => static float BEAT_STEP_NOTE;
  // the resolution in note duration (not actual time duration) of each beat step,
  // i.e. each advance of time (each addition to 'now')
  BEAT_STEP_NOTE / QUARTER_NOTE => static float BEAT_STEP;
  44100.0 => static float SAMPLING_RATE_PER_SEC;
  1::minute / 60 => dur SAMPLES_PER_SEC;

  dur SXTYFRTH;
  dur THRTYSCND;
  dur SXTNTH;
  dur ETH;
  dur QRTR;
  dur HLF;
  dur WHL;

  dur stepDur;
  dur beatDur;

  Event startEvent;
  Event stepEvent;
  /* Event updateEvent; */
  /* Event updateCompleteEvent; */
  /* Event playOutputEvent; */
  /* PlayerBase players[]; */
  0.0 => float NO_GAIN;

  // bpm - beats per minute, number of quarter notes per minute
  // i.e. 60 bpm means a quarter note is 1 second
  fun void init(float bpm, Event startEvent, Event stepEvent) // Event updateEvent,
                // Event updateCompleteEvent, Event playOutputEvent)
  {
    <<< "Clock: BEAT_STEP", BEAT_STEP >>>;
    <<< "Clock: SAMPLING_RATE_PER_SEC", SAMPLING_RATE_PER_SEC >>>;
    <<< "Clock: SAMPLES_PER_SEC", SAMPLES_PER_SEC >>>;

    bpm / 60.0 => float beatsPerSec;

    <<< "Clock: bpm", bpm, "beatsPerSec", beatsPerSec >>>;

    SAMPLES_PER_SEC / beatsPerSec =>  dur samplesPerBeat;

    <<< "Clock: samplesPerBeat", samplesPerBeat >>>;

    samplesPerBeat => beatDur;
    samplesPerBeat / BEAT_STEP => stepDur;

    <<< "Clock: beatDur", beatDur >>>;
    <<< "Clock: stepDur", stepDur >>>;

    startEvent @=> this.startEvent; 
    stepEvent @=> this.stepEvent;
    /* updateEvent @=> this.updateEvent; */
    /* updateCompleteEvent @=> this.updateCompleteEvent; */
    /* playOutputEvent @=> this.playOutputEvent; */

    D(0.015625) => SXTYFRTH;
    D(0.03125) => THRTYSCND;
    D(0.0625) => SXTNTH;
    D(0.125) => ETH;
    D(0.25) => QRTR;
    D(0.5) => HLF;
    D(1.0) => WHL;

    <<< "Clock: SXTYFRTH", SXTYFRTH, "THRTYSCND", THRTYSCND, "SXTNTH", SXTNTH, "ETH", ETH, "QRTR", QRTR, "HLF", HLF, "WHL", WHL >>>;
  }

  // Split from init() so users like NoteConst and ScaleConst which only need to calculate durations
  // don't need a dependency on Player. TODO would likely be better to refactor into two classes
  /* fun void registerPlayers(PlayerBase players[]) { */
  /*   players @=> this.players; */
  /* } */

  fun void play() {
    // TODO REALLY UNDERSTAND THIS. DO WE NEED BOTH SYNCS?
    // Sync now to closest next tempo duration unit
    sync();
    // Block here and wake up all Players, they will advance to block together on stepEvent.
    this.startEvent.broadcast();
    // Sync again to closest next tempo duration unit, all threads are now using synced time.
    sync();

    Util u;
    while (true) {

      // TEMP DEBUG
      /* <<< "CLOCK BEFORE STEP EVENT BROADCAST" >>>; */

      // Block on the Event that another tempo duration has passed and wake up all Players.
      // Players calculate new value for time passed vs. the duration of the current Note
      // they are playing and stop Note, start new Note etc. if they need to, then they
      // block again on the same Event and control comes back here.
      this.stepEvent.broadcast();

      // TEMP DEBUG
      /* <<< "CLOCK AFTER STEP EVENT BROADCAST" >>>; */

      // TEMP DEBUG
      /* <<< "CLOCK BEFORE STEPDUR NOW" >>>; */

      // Advance global time by smallest defined tempo duration, also shared with players.
      // When Clock blocks on Event and Players block on Event, then this means `now` advances
      // time globally for all shreds. (If there is no Event then each shred advances time
      // for its shred only by chucking durations to `now`).
      this.stepDur => now;

      // TEMP DEBUG
      /* <<< "CLOCK AFTER STEPDUR NOW" >>>; */

      // One player at a time released to update state, including global ensemble state. This is
      // just computation not output. Serialized access because there is shared global state
      // and Chuck has no critical-section style locking, only what amounts to co-routine
      // coordination where worker threads can block on an event and a control thread can allow one
      // or all of them to advance by signal() or broadcast() on the event.
      // So the first loop lets each player update its state without errors caused by updating
      // shared state. Then the second broadcast() lets them all play their output.
      // Then they block again, and the top of the loop here advances the clock and then we
      // repeat the cycle.
      // So randomize so that players update state based on each more "concurrently" as they
      // would in reality
      /* u.permutation(0, players.size() - 1) @=> int playerIdxs[]; */
      /* for (0 => int i; i < playerIdxs.size(); i++) { */

        // TEMP DEBUG
        /* <<< "CLOCK BEFORE UPDATE() player addr", players[playerIdxs[i]], "idx", playerIdxs[i] >>>; */

        // TODO
        // The idea is
        // - loop without blocking in this control loop while incrementing time, whih
        //   successively unblocks and advances time in each Player loop until all are blocked on update
        // - always signal update here, which is a no-op if no Player is blocked and releases one
        //   to start update if any oare blocked on update
        // - signal to start update MUST block this thread so that the only advancing thread is the
        //   signalled Player
        // - therefore the signalled Player MUST unblock this thread so that it can iterate in event loop
        //   and again signal, thus advancing time and then unblocking the next Player, etc.
        // How to do this
        // - players block on stepEvent
        // - each clock iteration starts by advancinb time, i.e. singalling stepEvent
        // - players block on updateEvent only when time has advanced to the end of their current note,
        //   i.e. they are ready to play, TODO THIS DOESN'T MAKE SENSE TO COUPLE UPDATING AND PLAYING,
        //   WHY ISN'T STATE ADVANCING ON EVERY TIME IERATION AND THEN NOTES ARE EMITTED WHEN TIME
        //   HAS ADVANCED TO THE NEXT NOTE?
        // - Clock signalling updateEvent must block clock itself, does this by passing Event that it will
        //   block on INTO a wrapper call or each Player has a reference to clock or the event, so
        //   Clock calls signal wrapper, which calls clockBlock.blockMe() and the calls updateEvent.signal()
        //   and then does the update and then calls clockBloc.unblockMe() and then blocks on outputEvent
        //   TODO AGAIN THIS DOES NOT MAKE SENSE TO COUPLE UPDATE AND OUTPUT 

        /* players[playerIdxs[i]].signalUpdate(); */
        /* updateEvent.signalUpdate(updateCompleteEvent); */

        // TEMP DEBUG
        /* <<< "CLOCK AFTER UPDATE() idx", playerIdxs[i] >>>; */
        // TODO BUG NEED TO BLOCK HERE AND EACH PLAYER SIGNALS BACK TO THE CLOCK AFTER IT IS DONE UPDATE
        /* updateCompleteEvent => now; */
      /* } */

      // TEMP DEBUG
      /* <<< "CLOCK BEFORE PLAY OUTPUT EVENT BROADCAST" >>>; */

      /* playOutputEvent.broadcast(); */

      // TEMP DEBUG
      /* <<< "CLOCK AFTER PLAY OUTPUT EVENT BROADCAST" >>>; */
    }
  }

  // Western notation note durations
  fun dur whole() {
    return this.beatDur * 4;
  }

  fun dur half() {
    return this.beatDur * 2;
  }

  fun dur quarter() {
    return this.beatDur;
  }

  fun dur eighth() {
    return this.beatDur / 2;
  }

  fun dur sixteenth() {
    return this.beatDur / 4;
  }

  fun dur thirtySecond() {
    return this.beatDur / 8;
  }

  fun dur sixtyFourth() {
    return this.beatDur / 16;
  }

  fun dur D(float noteDur) {
    return (this.beatDur * 4) * noteDur;
  }

  /**
   * Sync to a beat duration
   */
  fun static void sync(dur stepDur) {
    stepDur - (now % stepDur) => now;
  }

  /**
   * Sync to the configured beat duration
   */
  fun void sync() {
    sync(this.stepDur);
  }
}
