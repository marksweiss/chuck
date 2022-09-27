// Machine.add("lib/comp/instrument.ck")

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
  dur SIXTNTH;
  dur EITH;
  dur QRTR;
  dur HLF;
  dur WHL;

  dur stepDur;
  dur beatDur;

  Event startEvent;
  Event stepEvent;

  // bpm - beats per minute, number of quarter notes per minute
  // i.e. 60 bpm means a quarter note is 1 second
  fun void init(float bpm, Event startEvent, Event stepEvent) {
    <<< "BEAT_STEP", BEAT_STEP >>>;
    <<< "SAMPLES_PER_SEC", SAMPLES_PER_SEC >>>;

    bpm / 60.0 => float beatsPerSec;

    <<< "bpm", bpm, "beatsPerSec", beatsPerSec >>>;

    SAMPLES_PER_SEC / beatsPerSec =>  dur samplesPerBeat;

    <<< "SAMPLES PER BEAT", samplesPerBeat >>>;

    samplesPerBeat => beatDur;
    samplesPerBeat / BEAT_STEP => stepDur;

    <<< "stepDur", stepDur >>>;

    startEvent @=> this.startEvent; 
    stepEvent @=> this.stepEvent;

    D(0.015625) => dur SXTYFRTH;
    D(0.03125) => dur THRTYSCND;
    D(0.0625) => dur SXTNTH;
    D(0.125) => dur EITH;
    D(0.25) => dur QRTR;
    D(0.5) => dur HLF;
    D(1.0) => dur WHL;
  }

  fun void play() {
    /* <<< "IN CLOCK PLAY BEFORE START, shred id:", me.id() >>>; */

    sync();

    this.startEvent.broadcast();
    me.yield();

    /* <<< "IN CLOCK START passed" >>>; */

    sync();
    while (true) {
      stepEvent.broadcast();
      me.yield();

      /* <<< "IN CLOCK EVENT LOOP AFTER STEP BROADCAST BEFORE PITCHING", now, stepDur >>>; */

      stepDur => now;

      /* <<< "IN CLOCK EVENT LOOP AFTER PITCHING STEP_DUR => NOW", now >>>; */
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
