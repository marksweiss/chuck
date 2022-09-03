// Based on https://chuck.stanford.edu/doc/learn/notes/tg.ck
// name: tg.ck
// desc: TimeGrid class; basic timing operations abbreviated
// author: Graham Coleman 

// TODO SOME MODEL OF HOLDING REFERENCES TO EVENTS AND RECIEVING EVENT SIGNALS
// AND ADVANCING TIME FOR SIGNALS

public class Time {
  4 => QUARTER_NOTE_NUM_BEATS;
  dur beatDur;
  dur measureDur;
  int numBeats;
  int numMeasures;

  fun void init(int bpm, int numBeats, int numMeasures) {
    // 1 minute /
    // beats per minute /
    // ratio of num beats per measure to quarter note (4 per measure)
    1::minute / bpm / (numBeats / QUARTER_NOTE_NUM_BEATS) => this.beatDur;
    numBeats => this.numBeats;
    numMeasures => this.numMeasures;
    this.beatDur * this.numBeats => measureDur;
  }

  /**
   * Sync to a beat duration
   */
  fun void sync(dur beatDur_) {
    beatDur_ - (now % beatDur_) => now;
  }

  /**
   * Sync to the configured beat duration
   */
  fun void sync() {
    sync(this.beatDur);
  }

}
