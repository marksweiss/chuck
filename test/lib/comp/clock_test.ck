// cli: chuck test/assert.ck lib/arg_parser/arg_base.ck
//            lib/arg_parser/int_arg.ck lib/arg_parser/float_arg.ck lib/arg_parser/string_arg.ck
//             lib/arg_parser/duration_arg.ck lib/arg_parser/time_arg.ck
//            lib/collection/arg_map.ck lib/comp/conductor.ck lib/comp/clock.ck
//            test/lib/comp/clock_test.ck

"Test Clock" => string TEST_SUITE;

fun void testBeatDur() {
  // setup
  "testBeatDur" => string testName;
  "beatDur should be SAMPLES_PER_SEC / (bpm / 60.0)" => string msg;
  
  // this bpm means one beat is one second so beatDur is SAMPLES_PER_SEC
  60.0 => float bpm;
  Event startEvent;
  Event stepEvent;
  // TODO MOVE TO PLAYER
  Conductor conductor;
 
  // call 
  Clock clock;
  clock.init(bpm, startEvent, stepEvent, conductor);
  
  // assert
  Assert.assert(clock.beatDur, clock.SAMPLES_PER_SEC, testName, msg);
}

fun void testStepDur() {
  // setup
  "testStepDur" => string testName;
  "stepDur should be (SAMPLES_PER_SEC / (bpm / 60.0) / (QUARTER_NOTE / BEAT_STEP_NOTE))" => string msg;
  
  // this bpm means one beat is one second so beatDur is SAMPLES_PER_SEC
  60.0 => float bpm;
  Event startEvent;
  Event stepEvent;
  // TODO MOVE TO PLAYER
  Conductor conductor;
 
  // call 
  Clock clock;
  clock.init(bpm, startEvent, stepEvent, conductor);
     
  // assert
  clock.beatDur / (clock.QUARTER_NOTE / clock.BEAT_STEP_NOTE) => dur actualStepDur;
  clock.SAMPLES_PER_SEC / 16.0 => dur expectedStepDur;
  Assert.assert(clock.beatDur, clock.SAMPLES_PER_SEC, testName, msg);
}

fun void test() {
  <<< "\nRunning Test Suite:", TEST_SUITE >>>;
  testBeatDur();
  testStepDur();
}

test();
