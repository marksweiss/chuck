// Depends on: Machine.add("scale.ck");

public class Chord {
  // Chords
  // common triads in Western music, as degrees from the chord root
  // Note these are 0-based, but in traditional music theory scales etc. are 1-based
  [0, 4, 7] @=> static int MAJOR[];  // So, 0th, 2nd and 4th offset are degrees 1, 4, 7 e.g. C-E-G for C MAJOR
  [0, 4, 7] @=> static int M[];  // common alias
  [0, 3, 7] @=> static int MINOR[];  
  [0, 3, 7] @=> static int m[];  
  [0, 3, 6] @=> static int DIMINISHED[];
  [0, 3, 6] @=> static int dim[];
  [0, 4, 8] @=> static int AUGMENTED[];
  [0, 4, 8] @=> static int aug[];
  
  // "cannot declare static non-primitive objects (yet) ..."
  Scale s;
  
  fun int[] triad(int chord[], int octave, int rootNotePosition, int scale[]) {
    return triad(chord, octave, rootNotePosition, scale, Scale.NUM_NOTES_IN_OCTAVE);
  } 

  // Because field can't be static, functions using it can't be either, which isn't so terrible
  // because static functions are also broken and need to be called through an object ref anyway,
  // so this being non-static doesn't change client call syntax
  fun int[] triad(int chord[], int octave, int rootNotePosition, int scale[], int numNotesInOctave) {
    s.note(octave, rootNotePosition, scale, numNotesInOctave) => int note;
    return [note, note + chord[1], note + chord[2]];
  } 
}

fun void main() {
  4 => int octave;
  2 => int rootNotePosition;
  Chord ch;
  ch.triad(Chord.MAJOR, octave, rootNotePosition, Scale.MAJOR) @=> int chordNotes[];
  <<< "Chord:", ch >>>;
  <<< "Notes:", chordNotes[0], chordNotes[1], chordNotes[2] >>>;
}

main();
