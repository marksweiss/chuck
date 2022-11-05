// chuck test/assert.ck
//      lib/arg_parser/arg_base.ck lib/arg_parser/int_arg.ck lib/arg_parser/float_arg.ck lib/arg_parser/string_arg.ck
//        lib/arg_parser/duration_arg.ck lib/arg_parser/time_arg.ck
//      lib/collection/arg_map.ck
//      lib/comp/note.ck lib/comp/chord.ck lib/comp/scale.ck
//        lib/comp/conductor.ck lib/comp/clock.ck
//        lib/comp/note_const.ck lib/comp/scale_const.ck
//      test/lib/comp/scale_test.ck

"Test Scale" => string TEST_SUITE;

fun void testPitchName() {
  // setup
  "testPitchName" => string testName;
  "pitchName() returns expected string pitch name for pitch enum" => string msg;

  // call
  NoteConst nc;
  nc.pitchName(NoteConst.Cs) => string actual;

  // assert
  "Cs" => string expected;
  Assert.assert(expected, actual, testName, msg);
}

fun void testPitch() {
  // setup
  "testPitch" => string testName;
  "pitch() returns expected pitch value for pitch enum and octave" => string msg;

  // call
  Scale s;
  2 => int octave;
  s.pitch(octave, NoteConst.Cs) => int actual;

  // assert
  NoteConst.Cs + (octave * Scale.NUM_NOTES_IN_OCTAVE) => int expected;
  Assert.assert(expected, actual, testName, msg);
}

fun void testPitchFromScale() {
  // setup
  "testPitchFromScale" => string testName;
  "pitch() returns expected pitch value for degree, octave and scale" => string msg;

  // call
  Scale s;
  // access MAJOR with instance var because it's an array
  ScaleConst SC;
  5 => int octave;
  5 => int degree;
  s.pitch(octave, degree, SC.MAJOR) => int actual;

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
  s.freq(octave, NoteConst.A) => float actual;

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
  // access MAJOR with instance var because it's an array
  ScaleConst SC;
  5 => int octave;
  5 => int degree;
  s.freq(octave, degree, SC.MAJOR) => float actual;

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
  // access MAJOR with instance var because it's an array
  ScaleConst SC;
  5 => int octave;
  s.triad(octave, NoteConst.C, SC.MAJOR, SC.MAJOR_TRIAD) @=> int actual[];

  // assert
  [60, 64, 67] @=> int expected[];
  Assert.assert(expected, actual, testName, msg);
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
