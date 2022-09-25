// cli: $> chuck lib/comp/note.ck lib/comp/chord.ck \
//               lib/comp/sequence.ck

// TODO TEST
public class Sequence {
  Chord chords[0];
  0 => int idx;
  false => int isLooping;

  fun void init(int isLooping) {
    isLooping => this.isLooping;
  }

  fun void add(Chord chord) {
    // dynamically resize with << operator, per here:
    // https://chuck.stanford.edu/doc/examples/array/array_dynamic.ck
    this.chords << chord;
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

  fun Chord next() {
    // If iterator has no more items return "empty" Chord. API is for user to
    // loop on a poll of hasNext()
    if (!hasNext()) {
      Chord c;
      return c;
    }
    chords[idx] @=> Chord ret;
    idx++;
    return ret; 
  }

  fun int hasNext() {
    if (this.idx == chords.size()) {
      if (this.isLooping) {
        0 => this.idx;
        return true;
      }
      <<< "WARN: next() called for position greater than size:", chords.size() >>>;
      return false;
    }
    return true;
  }
}
