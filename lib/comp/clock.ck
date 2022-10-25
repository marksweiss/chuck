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
  // i.e.. each advance of time (each addition to 'now')
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
  Conductor conductor;

  // bpm - beats per minute, number of quarter notes per minute
  // i.e. 60 bpm means a quarter note is 1 second
  fun void init(float bpm, Event startEvent, Event stepEvent, Conductor conductor) {
    conductor @=> this.conductor;

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

    D(0.015625) => SXTYFRTH;
    D(0.03125) => THRTYSCND;
    D(0.0625) => SXTNTH;
    D(0.125) => ETH;
    D(0.25) => QRTR;
    D(0.5) => HLF;
    D(1.0) => WHL;

    <<< "Clock: SXTYFRTH", SXTYFRTH, "THRTYSCND", THRTYSCND, "SXTNTH", SXTNTH, "ETH", ETH, "QRTR", QRTR, "HLF", HLF, "WHL", WHL >>>;
  }

  fun void play() {
    sync();

    this.startEvent.broadcast();
    me.yield();

    sync();
    while (true) {
      // call the conductor to calculate new global state for all instrument player threads
      this.conductor.nextStateBool();

      this.stepEvent.broadcast();
      me.yield();

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
