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
    if (idx == chords.size()) {
      if (!isLooping) {
        return null;
      } else {
        reset(); 
      }
    }
    
    idx++;
    return chords[idx - 1];
  }

  fun Chord current() {
    if (idx >= chords.size()) {
      if (!isLooping) {
        <<< "ERROR: call to current() when idx >= size and !isLooping" >>>;
        me.exit();
      } else {
        reset();
      }
    }
    return chords[idx];
  }

  fun void reset() {
    0 => idx;
  }
}
