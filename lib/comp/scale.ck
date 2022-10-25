// Borrows from https://chuck.stanford.edu/doc/learn/notes/scale.ck

// Machine.add("lib/comp/chord.ck")
// Machine.add("lib/comp/scale.ck")

public class Scale {
  // default to Western 12-note "piano" scale
  12 => static int NUM_NOTES_IN_OCTAVE;

  string PITCH_STR_MAP[12];
  "C" @=> PITCH_STR_MAP[0];
  "C_shp" @=> PITCH_STR_MAP[1];
  "D" @=> PITCH_STR_MAP[2];
  "E_flt" @=> PITCH_STR_MAP[3];
  "F" @=> PITCH_STR_MAP[5];
  "F_shp" @=> PITCH_STR_MAP[6];
  "G" @=> PITCH_STR_MAP[7];
  "A_flt" @=> PITCH_STR_MAP[8];
  "A" @=> PITCH_STR_MAP[9]; 
  "B_flt" @=> PITCH_STR_MAP[10]; 
  "B" @=> PITCH_STR_MAP[11]; 

  // SCALE API
  // Should be static but uses array, which can't be static
  fun string pitchName(int pitchPosition) {
    return pitchName(pitchPosition, NUM_NOTES_IN_OCTAVE);
  } 

  // Should be static but uses array, which can't be static
  fun string pitchName(int pitchPosition, int numNotesInOctave) {
    return PITCH_STR_MAP[pitchPosition % numNotesInOctave];
  } 

  // TODO TESTS FOR THESE FOUR METHODS AND THE REST OF THIS CLASS
  fun static int pitch(int octave, int pitchName) {
    return pitch(octave, pitchName, NUM_NOTES_IN_OCTAVE);
  }

  fun static int pitch(int octave, int pitchName, int numNotesInOctave) {
    return (octave * numNotesInOctave) + pitchName;
  }

  fun static float freq(int octave, int pitchName) {
    return freq(octave, pitchName, NUM_NOTES_IN_OCTAVE);
  }

  fun static float freq(int octave, int pitchName, int numNotesInOctave) {
    return Std.mtof(pitch(octave, pitchName, numNotesInOctave));
  }

  /** 
   * Translates an index into a scale into the degree of that index position in the scale,
   * and then offsets that degree upward from `octave * NUM_NOTES_IN_OCTAVE` to get a final
   * integer note value. This can be used directly in MIDI or translated to a frequency with std.mtof().
   * Uses default NUM_NOTES_IN_OCTAVE to compute final note.
   *  
   * octave - octave in which to place note
   * pitchPosition - the index in the scale to return the degree for
   * scale - the scale from which to select the degree for pitchPosition
  */
  fun static int pitch(int octave, int pitchPosition, int scale[]) {
    return pitch(octave, pitchPosition, scale, NUM_NOTES_IN_OCTAVE);
  }

  /** 
   * Translates an index into a scale into the degree of that index position in the scale,
   * and then offsets that degree upward from `octave * NUM_NOTES_IN_OCTAVE` to get a final
   * integer note value. This can be used directly in MIDI or translated to a frequency with std.mtof().
   * 
   * octave - octave in which to place note
   * pitchPosition - the index in the scale to return the degree for
   * scale - the scale from which to select the degree for pitchPosition
   * numNotesInOctave - instead of using class static default, override for other scales
  */ 
  fun static int pitch(int octave, int pitchPosition, int scale[], int numNotesInOctave) {
    pitchPosition % scale.size() => int offset;
    return (octave * numNotesInOctave) + scale[offset];
  }

  /** 
  /** 
   * Translates an index into a scale into the degree of that index position in the scale,
   * and then offsets that degree upward from `octave * NUM_NOTES_IN_OCTAVE` to get a final
   * integer note value. This can be used directly in MIDI or translated to a frequency with std.mtof().
   * Uses default NUM_NOTES_IN_OCTAVE to compute final note.
   *  
   * octave - octave in which to place note
   * pitchPosition - the index in the scale to return the degree for
   * scale - the scale from which to select the degree for pitchPosition
  */
  fun static int pitch(int octave, int pitchPosition, int scale[]) {
    return pitch(octave, pitchPosition, scale, NUM_NOTES_IN_OCTAVE);
  }

  /** 
   * Translates an index into a scale into the degree of that index position in the scale,
   * and then offsets that degree upward from `octave * NUM_NOTES_IN_OCTAVE` to get a final
   * integer note value. This can be used directly in MIDI or translated to a frequency with std.mtof().
   * 
   * octave - octave in which to place note
   * pitchPosition - the index in the scale to return the degree for
   * scale - the scale from which to select the degree for pitchPosition
   * numNotesInOctave - instead of using class static default, override for other scales
  */ 
  fun static int pitch(int octave, int pitchPosition, int scale[], int numNotesInOctave) {
    pitchPosition % scale.size() => int offset;
    return (octave * numNotesInOctave) + scale[offset];
  }

  /** 
   * Translates an index into a scale into the frequency of the note at that index, offset to octave.
   *  
   * octave - octave in which to place note
   * pitchPosition - the index in the scale to return the degree for
   * scale - the scale from which to select the frequency for pitchPosition
  */ 
  fun static float freq(int octave, int pitchPosition, int scale[]) {
    return freq(octave, pitchPosition, scale, NUM_NOTES_IN_OCTAVE);
  }

  /** 
   * Translates an index into a scale into the frequency of the note at that index, offset to octave.
   * 
   * octave - octave in which to place note
   * pitchPosition - the index in the scale to return the frequency for
   * scale - the scale from which to select the frequency for pitchPosition
   * numNotesInOctave - instead of using class static default, override for other scales
  */ 
  fun static float freq(int octave, int pitchPosition, int scale[], int numNotesInOctave) {
    return Std.mtof(pitch(octave, pitchPosition, scale, numNotesInOctave));
  }

  // TODO DOC STRINGS
  // CHORD API
  fun static int[] triad(int octave, int rootPitch, int chord[], int numNotesInOctave) {
    (octave * numNotesInOctave) + rootPitch => int pitch;
    return [pitch, pitch + chord[1], pitch + chord[2]];
  } 

  fun static int[] triad(int octave, int rootPitch, int chord[]) {
    return triad(octave, rootPitch, chord, NUM_NOTES_IN_OCTAVE);
  } 

  fun static int[] triad(int octave, int rootPitchPosition, int scale[], int chord[]) {
    return triad(octave, rootPitchPosition, Scale.NUM_NOTES_IN_OCTAVE, scale, chord);
  } 

  // Because field can't be static, functions using it can't be either, which isn't so terrible
  // because static functions are also broken and need to be called through an object ref anyway,
  // so this being non-static doesn't change client call syntax
  fun static int[] triad(int octave, int rootPitchPosition, int numNotesInOctave, int scale[],
      int chord[]) {
    pitch(octave, rootPitchPosition, scale, numNotesInOctave) => int pitch;
    return [pitch, pitch + chord[1], pitch + chord[2]];
  }
}
