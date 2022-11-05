// cli: chuck test/assert.ck lib/arg_parser/arg_base.ck lib/arg_parser/int_arg.ck \
//            lib/comp/note.ck lib/comp/chord.ck lib/comp/sequence.ck test/lib/comp/sequence_test.ck

"Test Sequence" => string TEST_SUITE;

fun void testAddSize() {
  // setup
  "testAddSize" => string testName;
  "add(chord) appends chord to sequence, increases size by 1" => string msg;
  false => int isLooping;
  100.0 => float freq;
  1.0 => float gain; 
  1::second => dur duration;
  Note n;
  n.make(freq, gain, duration) @=> Note note;
  Chord c;
  c.make(note) @=> Chord chord;

  Sequence s;
  s.init(isLooping);

  // call
  s.add(chord);
  s.size() => int seqSize;

  // assert
  Assert.assert(seqSize, 1, testName, msg);
}

fun void testNext() {
  // setup
  "testNext" => string testName;
  "next returns next chord in sequence, null if not looping and at end of sequence, 0th element if looping and at end of sequence" => string msg;
  100.0 => float freq;
  1.0 => float gain; 
  1::second => dur duration;
  Note n;
  // pass Note instead of chord when constructing Sequence to exercise this code path
  // last test constructed from Chord
  n.make(freq, gain, duration) @=> Note note1;
  n.make(freq, gain, duration) @=> Note note2;

  false => int isLooping;
  Sequence s;
  s.init(isLooping);
  s.add(note1);
  s.add(note2);

  // call
  s.next() @=> Chord chord1;
  s.next() @=> Chord chord2;
  s.next() @=> Chord chord3;

  // assert
  // TODO Note equals and Chord equals
  Assert.assert(true, chord1.notes[0].equals(note1), testName, msg);
  Assert.assert(true, chord2.notes[0].equals(note2), testName, msg);
  Assert.assert(true, chord3 == null, testName, msg);
}

fun void testIsLooping() {
  // setup
  "testNext" => string testName;
  "next returns next chord in sequence, null if not looping and at end of sequence, 0th element if looping and at end of sequence" => string msg;
  100.0 => float freq;
  1.0 => float gain; 
  1::second => dur duration;
  Note n;
  // pass Note instead of chord when constructing Sequence to exercise this code path
  // last test constructed from Chord
  n.make(freq, gain, duration) @=> Note note1;
  n.make(freq, gain, duration) @=> Note note2;

  // set looping true
  true => int isLooping;
  Sequence s;
  s.init(isLooping);
  s.add(note1);
  s.add(note2);

  // call
  s.next() @=> Chord chord1;
  s.next() @=> Chord chord2;
  // expect that iterating past the end resets to return the first chord in the sequence
  s.next() @=> Chord chord3;

  // assert
  Assert.assert(true, chord1.notes[0].equals(note1), testName, msg);
  Assert.assert(true, chord2.notes[0].equals(note2), testName, msg);
  Assert.assert(true, chord3.notes[0].equals(note1), testName, msg);
}

fun void test() {
  <<< "\nRunning Test Suite:", TEST_SUITE >>>;
  testAddSize();
  testNext();
}

test();
