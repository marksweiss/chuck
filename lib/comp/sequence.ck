// cli: $> chuck lib/comp/note.ck lib/comp/chord.ck \
//               lib/comp/sequence.ck

public class Sequence {
  string name;
  Chord chords[0];
  0 => int idx;
  false => int isLooping;

  fun void init(int isLooping) {
    Std.itoa(me.id()) => this.name;
    isLooping => this.isLooping;
  }

  fun void init(string name, int isLooping) {
    name => this.name;
    isLooping => this.isLooping;
  }
  
  // ***
  // Container interface
  fun void add(Chord chord) {
    Chord c;
    // dynamically resize with << operator, per here:
    // https://chuck.stanford.edu/doc/examples/array/array_dynamic.ck
    this.chords << c.make(chord);
  }

  fun void add(Chord chords[]) {
    for (0 => int i; i < chords.size(); i++) {
      add(chords[i]);
    }
  }

  /**
   * Accepts a sequence of notes and makes each one a one-note Chord, i.e. treats them
   * as a sequence of monophonic notes
   */
  fun void add(Note notes[]) {
    Chord c; // to make static call to make()
    for (0 => int i; i < notes.size(); i++) {
      add(c.make(notes[i]));     
    }
  }

  /**
   * Accepts a note and makes each a one-note Chord
   */
  fun void add(Note note) {
    Chord c; // to make static call to make()
    add(c.make(note));     
  }

  fun int size() {
    return chords.size();
  }
  // ***

  // *** Iterator interface
  fun Chord next() {

    // TEMP DEBUG
    <<< "IN next(), size", chords.size(), "idx", idx >>>;
  
    if (idx == chords.size()) {
      if (!isLooping) {
        return null;
      } else {

        // TEMP DEBUG
        /* <<< "IN next() RESET, size", chords.size(), "idx", idx >>>; */
  
        reset(); 
      }
    }
    
    idx++;

    // TEMP DEBUG
    /* if (idx > 1) { */
      <<< "IN next() AFTER idx incr, size", chords.size(), "idx", idx >>>;
    /* } */ 

    return chords[idx - 1];
  }

  fun Chord nextOnce() {
    if (idx == chords.size()) {
      return null;
    }
    idx++;
    return chords[idx - 1];
  }

  fun Chord current() {

    // TEMP DEBUG
    /* <<< "IN current(), size", chords.size(), "idx", idx >>>; */
  
    if (idx >= chords.size()) {
      if (isLooping) {
        reset();
      }
    }
    return chords[idx];
  }

  fun Chord currentNoReset() {
    if (idx >= chords.size()) {
      return null;
    }
    return chords[idx];
  }

  fun void reset() {
    0 => idx;
  }
}
