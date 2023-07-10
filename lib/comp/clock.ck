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
  // This is the resolution for updating state. Samples per second is the internal resolution for the data ultimately
  // making up the audio. This is the resoltuion at which the event loop advances the clock and therefore at which
  // the internal state is updated. So, effectively, samples are written at this resolution and repeat for the length
  // of this resoluttion: 1.5, 1.5, 1.5, 2.5, 2.5, 2.5, 6.42, 6.42, 6.42, ...
  10000 => float BPM_RESOLUTION_PER_SEC;
  SAMPLES_PER_SEC / BPM_RESOLUTION_PER_SEC => dur SAMPLES_PER_STEP; 

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
  0.0 => float NO_GAIN;

  // bpm - beats per minute, number of quarter notes per minute
  // i.e. 60 bpm means a quarter note is 1 second
  fun void init(float bpm, Event startEvent, Event stepEvent) {
    <<< "Clock: BPM", bpm >>>;
    <<< "Clock: BEAT_STEP", BEAT_STEP >>>;
    <<< "Clock: SAMPLING_RATE_PER_SEC", SAMPLING_RATE_PER_SEC >>>;
    <<< "Clock: SAMPLES_PER_SEC", SAMPLES_PER_SEC >>>;
    <<< "Clock: SAMPLES_PER_STEP", SAMPLES_PER_STEP >>>;

    bpm / 60.0 => float beatsPerSec;
    <<< "beatsPerSec", beatsPerSec >>>;

    SAMPLES_PER_SEC / beatsPerSec =>  dur samplesPerBeat;
    <<< "Clock: samplesPerBeat", samplesPerBeat >>>;

    samplesPerBeat => beatDur;
    <<< "Clock: beatDur", beatDur >>>;

    // TODO GET RID OF THIS AS A CLASS-LEVEL FIELD, it's const
    SAMPLES_PER_STEP => stepDur;
    <<< "Clock: stepDur", stepDur >>>;

    startEvent @=> this.startEvent; 
    stepEvent @=> this.stepEvent;

    D(0.015625) => SXTYFRTH;
    D(0.03125) => THRTYSCND;
    D(0.0625) => SXTNTH;
    D(0.125) => ETH;
    D(0.25) => QRTR;
    D(0.5) => HLF;
    D(1.0) => WHL;

    <<< "Clock: SXTYFRTH", SXTYFRTH, "THRTYSCND", THRTYSCND, "SXTNTH", SXTNTH, "ETH", ETH, "QRTR", QRTR, "HLF", HLF, "WHL", WHL >>>;
  }

  // TODO BELOW SUGGESTION WON'T REMOVE DEPENDENCY
  //  correct approach is a wrapper ClockPlayers class with a Clock member and an array of Players
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
      // Block on the Event that another tempo duration has passed and wake up all Players.
      // Players calculate new value for time passed vs. the duration of the current Note
      // they are playing and stop Note, start new Note etc. if they need to, then they
      // block again on the same Event and control comes back here.
      this.stepEvent.broadcast();

      // Advance global time by smallest defined tempo duration, also shared with players.
      // When Clock blocks on Event and Players block on Event, then this means `now` advances
      // time globally for all shreds. (If there is no Event then each shred advances time
      // for its shred only by chucking durations to `now`).
      this.stepDur => now;
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
