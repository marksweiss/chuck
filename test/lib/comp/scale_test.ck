// cli: chuck test/assert.ck lib/comp/scale.ck test/lib/comp/scale_test.ck

"Test Scale" => string TEST_SUITE;

/* fun void main() { */
/*   4 => int octave; */
/*   // static functions are broken and can't be called except through an object reference, i.e. not static */
/*   Scale s; */
/*   <<< s.pitch(octave, Scale.D, Scale.MAJOR) >>>; */
/*   <<< s.freq(octave, Scale.D, Scale.MAJOR) >>>; */
/*   s.triad(octave, Scale.D, Scale.MAJOR, Scale.MAJOR_TRIAD) @=> int chordPitches[]; */
/*   <<< "Chord:", chordPitches, "Length:", chordPitches.cap() >>>; */
/*   <<< "Pitches:", chordPitches[0], chordPitches[1], chordPitches[2] >>>; */
/*   <<< Scale.D, "==", s.pitchName(Scale.D) >>>; */
/* } */

fun void testPitchName() {
  // setup
  "testPitchName" => string testName;
  "pitchName() returns expected string pitch name for pitch enum" => string msg;

  // call
  Scale s;
  s.pitchName(s.C_shp) => string actual;

  // assert
  "C_shp" => string expected;
  Assert.assert(expected, actual, testName, msg);
}

fun void testPitch() {
  // setup
  "testPitch" => string testName;
  "pitch() returns expected pitch value for pitch enum and octave" => string msg;

  // call
  Scale s;
  2 => int octave;
  s.pitch(octave, s.C_shp) => int actual;

  // assert
  s.C_shp + (octave * s.NUM_NOTES_IN_OCTAVE) => int expected;
  Assert.assert(expected, actual, testName, msg);
}

fun void testPitchFromScale() {
  // setup
  "testPitchFromScale" => string testName;
  "pitch() returns expected pitch value for degree, octave and scale" => string msg;

  // call
  Scale s;
  5 => int octave;
  5 => int degree;
  s.pitch(octave, degree, Scale.MAJOR) => int actual;

  // assert
  69 => int expected;
  Assert.assert(expected, actual, testName, msg);
}

fun void testFreq() {
  // setup
  "testFreq" => string testName;
  "freq() returns expected freq value for pitch enum and octave" => string msg;

  // call
  Scale s;
  // A4 is 440Hz, not sure why that is octave == 5 in Chuck
  5 => int octave;
  s.freq(octave, s.A) => float actual;

  // assert
  // A4 is 440Hz
  440.0 => float expected;
  Assert.assert(expected, actual, testName, msg);
}

fun void testFreqFromScale() {
  // setup
  "testFreqFromScale" => string testName;
  "freq() returns expected pitch value for degree, octave and scale" => string msg;

  // call
  Scale s;
  5 => int octave;
  5 => int degree;
  s.freq(octave, degree, Scale.MAJOR) => float actual;

  // assert
  440.0 => float expected;
  Assert.assert(expected, actual, testName, msg);
}

fun void testTriad() {
  // setup
  "testTriad" => string testName;
  "triad() returns expected chord pitches for octave, pitch enum, scale and chord type enum" => string msg;

  // call
  Scale s;
  5 => int octave;
  s.triad(octave, Scale.C, Scale.MAJOR, Scale.MAJOR_TRIAD) @=> int actual[];

  // assert
  [60, 64, 67] @=> int expected[];
  for (0 => int i; i < actual.cap(); i++) {
    Assert.assert(expected[i], actual[i], testName, msg);
  }
}

fun void test() {
  <<< "\nRunning Test Suite:", TEST_SUITE >>>;
  testPitchName();
  testPitch();
  testPitchFromScale();
  testFreq();
  testFreqFromScale();
  testTriad();
}

test();
