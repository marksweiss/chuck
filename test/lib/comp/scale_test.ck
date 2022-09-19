// cli: chuck test/assert.ck lib/comp/scale.ck

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

fun void test() {
  <<< "\nRunning Test Suite:", TEST_SUITE >>>;
  testPitchName();
}

fun void testPitch() {
  // setup
  "testPitch" => string testName;
  "pitch() returns expected pitch value for pitch enum" => string msg;

  // call
  Scale s;
  2 => int octave;
  s.pitch(octave, s.C_shp) => string actual;

  // assert
  "C_shp" => string expected;
  Assert.assert(expected, actual, testName, msg);
}

fun void test() {
  <<< "\nRunning Test Suite:", TEST_SUITE >>>;
  testPitchName();
}

test();
