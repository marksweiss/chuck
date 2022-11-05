// cli: chuck test/assert.ck lib/arg_parser/arg_base.ck lib/arg_parser/int_arg.ck \
//            lib/comp/note.ck lib/comp/chord.ck lib/comp/sequence.ck lib/comp/sequences.ck
//            test/lib/comp/sequences_test.ck

"Test Sequences" => string TEST_SUITE;

fun void testAddSize() {
  // setup
  "testAddSize" => string testName;
  "add(sequence) appends sequence to sequences, increases size by 1" => string msg;
  false => int isLooping;
  100.0 => float freq;
  1.0 => float gain; 
  1::second => dur duration;
  Note n;
  n.make(freq, gain, duration) @=> Note note;
  Chord c;
  c.make(note) @=> Chord chord;
  Sequence seq;
  seq.init(isLooping);
  seq.add(chord);

  // call
  Sequences seqs;
  seqs.init(isLooping);
  seqs.add(seq);
  seqs.size() => int seqsSize;  

  // assert
  Assert.assert(seqsSize, 1, testName, msg);
}

fun void testNext() {
  // setup
  "testNext" => string testName;
  "next returns next sequence in sequences, null if not looping and at end of sequence" => string msg;
  false => int isLooping;
  100.0 => float freq;
  1.0 => float gain; 
  1::second => dur duration;
  Note n;
  n.make(freq, gain, duration) @=> Note note;
  Chord c;
  c.make(note) @=> Chord chord;
  Sequence seq;
  seq.init(isLooping);
  seq.add(chord);

  // call
  Sequences seqs;
  seqs.init(isLooping);
  seqs.add(seq);
  seqs.add(seq);

  seqs.next() @=> Sequence seq1;
  seqs.next() @=> Sequence seq2;
  seqs.next() @=> Sequence seq3;

  Assert.assert(true, seq1.chords[0].notes[0].equals(note), testName, msg);
  Assert.assert(true, seq2.chords[0].notes[0].equals(note), testName, msg);
  Assert.assert(true, seq3 == null, testName, msg);
}

fun void testIsLooping() {
  // setup
  "testIsLooping" => string testName;
  "next returns next sequence in sequences, 0th element if looping and at end of sequence" => string msg;
  false => int isLooping;
  100.0 => float freq;
  1.0 => float gain; 
  1::second => dur duration;
  Note n;
  n.make(freq, gain, duration) @=> Note note;
  Chord c;
  c.make(note) @=> Chord chord;
  Sequence seq;
  seq.init(isLooping);
  seq.add(chord);

  // call
  Sequences seqs;
  true => int isSeqsLooping;
  seqs.init(isSeqsLooping);
  seqs.add(seq);
  seqs.add(seq);

  seqs.next() @=> Sequence seq1;
  seqs.next() @=> Sequence seq2;
  seqs.next() @=> Sequence seq3;

  Assert.assert(true, seq1.chords[0].notes[0].equals(note), testName, msg);
  Assert.assert(true, seq2.chords[0].notes[0].equals(note), testName, msg);
  Assert.assert(true, seq3.chords[0].notes[0].equals(note), testName, msg);
}
fun void test() {
  <<< "\nRunning Test Suite:", TEST_SUITE >>>;
  testAddSize();
  testNext();
  testIsLooping();
}

test();
