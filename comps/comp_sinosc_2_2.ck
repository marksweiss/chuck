/* chuck --loop test/assert.ck lib/arg_parser/arg_base.ck lib/arg_parser/int_arg.ck */
/* lib/arg_parser/float_arg.ck lib/arg_parser/time_arg.ck lib/arg_parser/duration_arg.ck */
/* lib/arg_parser/string_arg.ck lib/arg_parser/arg_parser.ck lib/collection/arg_map.ck */
/* lib/collection/object_map.ck lib/collection/set.ck lib/util/util.ck lib/concurrency/lock.ck */
/* lib/concurrency/coroutine.ck lib/concurrency/coroutine_controller.ck */
/* lib/comp/instrument/instrument_base.ck lib/comp/player_base.ck lib/comp/clock.ck lib/comp/note.ck */
/* lib/comp/chord.ck lib/comp/scale.ck lib/comp/sequence.ck lib/comp/sequences.ck lib/comp/note_const.ck */
/* lib/comp/scale_const.ck lib/comp/instrument/sinosc2.ck lib/comp/conductor.ck lib/comp/in_c_conductor.ck */
/* lib/comp/in_c_player.ck comps/comp_sinosc_2.ck */

// For client to spork, which requires a free function as entry point
public void runClock(Clock clock) {
  clock.play();
}

public void runPlayer(PlayerBase player) {
  player.play();
}

// TODO PARAMETERIZE ALL THESE PER PLAYER
fun ArgParser getConf(float modulateVibratoRate, dur attack, dur decay, dur release) {
  ArgParser conf;
  conf.addDurationArg("adsrAttack", attack);
  conf.addDurationArg("adsrDecay", decay);
  conf.addFloatArg("adsrSustain", 0.5);
  conf.addDurationArg("adsrRelease", release);
  conf.addFloatArg("chorusModFreq", 1100.0);
  conf.addFloatArg("chorusModDepth", 0.05);
  conf.addFloatArg("chorusMix", 0.05);
  /* conf.addFloatArg("modulateVibratoRate", modulateVibratoRate); */
  /* conf.addFloatArg("modulateVibratoGain", 0.5); */
  /* conf.addFloatArg("modulateRandomGain", 0.5); */
  conf.addDurationArg("delayDelay", 75::ms);
  conf.addDurationArg("delayMax", 100::ms);
  /* conf.addDurationArg("echoDelay", 10::ms); */
  /* conf.addDurationArg("echoMax", 20::ms); */
  /* conf.addFloatArg("echoMix", 0.5); */
  /* conf.addFloatArg("reverbMix", 0.05); */
  /* conf.addFloatArg("panPan", 0.0); */
  /* conf.addFloatArg("mixPan", 1.0); */
  conf.loadArgs();

  return conf;
}

fun void addPhrase(Note phraseNotes[], Sequences seqs[]) {
  for (0 => int i; i < seqs.size(); ++i) {
    seqs[i].add(makePhrase(phraseNotes, i));
  } 
}

fun Sequence makePhrase(Note phraseNotes[], int id) {
  Sequence seq;
  seq.init(Std.itoa(id), true);  // looping phrases 
  seq.add(phraseNotes);
  return seq;
}

fun void main () {
  // TODO
  // - Look at other UGens, work on better timbres for composition
  // - Experiment with micro-detune, (see detune example in book)
  // - JUST INTONATION!!!
  // - Dynamic signal processing example from Chuck book, Chapter 8
  // - Cleanup
  //   - move In C stuff into it's own directory

  // init clock, tempo and time advance Events
  10 => int NUM_PHRASES;
  3 => int NUM_PLAYERS;

  // TODO BUG BMP < 30 loops but produces no audio
  60 => int BPM;
  Event startEvent;
  Event stepEvent; 

  Clock clock;
  clock.init(BPM, startEvent, stepEvent);

  // declare sequence containers
  true => int isLooping;

  // For passing a copy of the initial, unmodified source sequences to the Conductor
  // so it can advance players to a clean copy of the next sequences, or undo changes
  // to the player copy of a sequence
  Sequences seqs0;
  seqs0.init("seqs0", isLooping);
  Sequences seqs1;
  seqs1.init("seqs1", isLooping);
  Sequences seqs2;
  seqs2.init("seqs2", isLooping);
  Sequences seqs3;
  seqs3.init("seqs3", isLooping);
  [seqs0, seqs1, seqs2, seqs3] @=> Sequences seqs[];

  // declare chords / notes for each sequence
  NoteConst N;
  N.init(BPM);
  Note T;
  ScaleConst S;
  S.init(BPM);

  addPhrase([N.C4_8, N.E4_4, N.C4_8, N.E4_4, N.C4_8, N.E4_4], seqs);
  addPhrase([N.C4_8, N.E4_8, N.F4_8, N.E4_4], seqs);
  addPhrase([N.REST_8, N.E4_8, N.F4_8, N.E4_8], seqs);
  addPhrase([N.REST_8, N.E4_8, N.F4_8, N.G4_8], seqs);
  addPhrase([N.E4_8, N.F4_8, N.G4_8, N.REST_8], seqs);
  addPhrase([N.C5_1, N.C5_1], seqs);
  addPhrase([N.REST_4, N.REST_4, N.REST_4, N.REST_8,
             N.C4_8, N.C4_8, N.C4_8,
             N.REST_8, N.REST_4, N.REST_4, N.REST_4], seqs);
  addPhrase([T.dotN(N.G4_1), N.F4_1, N.F4_1], seqs);
  addPhrase([N.B4_16, N.G4_16, N.REST_8, N.REST_4, N.REST_4, N.REST_4], seqs);
  addPhrase([N.B4_16, N.G4_16], seqs);

  // TODO PERFORMANCE
  // Add the rest of the phrases

  // TODO SOME OF THESE SHOULD BE DEFINED IN TERMS OF CLOCK calls to whole(), half() etc.
  // configure instruments, pass clock, Events, sequences of phrases and conductor to them 
  getConf(100, 10::ms, 20::ms, 10::ms) @=> ArgParser conf0;
  getConf(102.5, 10::ms, 20::ms, 10::ms) @=> ArgParser conf1;
  getConf(105, 10::ms, 20::ms, 10::ms) @=> ArgParser conf2;
  getConf(200, 10::ms, 20::ms, 10::ms) @=> ArgParser conf3;
  // TODO MAKE NAMING 0-based consistent
  // TODO PERFORMANCE
  // tune the instruments, add new kinds of instruments, add more players, make the performance interesting
  InstrSinOsc2 instr0;
  InstrSinOsc2 instr1; 
  InstrSinOsc2 instr2; 
  InstrSinOsc2 instr3; 
  instr0.init("instr0", conf0);
  instr1.init("instr1", conf1);
  instr2.init("instr2", conf2);
  instr3.init("instr3", conf3);

  
  instr0.so1 => instr0.chorus => instr0.echo => instr0.delay => instr0.rev => instr0.pan => instr0.env => instr0.g;
  instr1.so1 => instr1.chorus => instr1.echo => instr1.delay => instr1.rev => instr1.pan => instr1.env => instr1.g;
  /* instr2.so1 => instr2.chorus => instr2.echo => instr2.delay => instr2.rev => instr2.pan => instr2.env => instr2.g; */
  /* instr3.so1 => instr3.chorus => instr3.echo => instr3.delay => instr3.rev => instr3.pan => instr3.env => instr3.g; */
  instr0.g => dac.right; 
  instr1.g => dac.left; 
  /* instr2.g => dac; */ 
  /* instr1.g => dac; */ 

  // global coordinator of interprocess state governing composition behavior, such
  // as in this case whether instruments move to the next phrase or stay on the current one
  0 => int id;
  makePhrase([N.B4_16, N.G4_16], id) @=> Sequence lastPhrase;
  InCConductor conductor;
  conductor.init(NUM_PHRASES, NUM_PLAYERS, seqs0, lastPhrase);

  // declare the Players whose behavior governed by calling the Conductor to
  // to check their state changes, performing the notes of the Sequences using the
  // Instruments to play the notes

  CoroutineController CC;
  Coroutine cor;
  Lock lock;
  CoroutineController corPlayer0;
  // TODO init() overload that doesn't require IS_NOT_HEAD / IS_HEAD because now support signalRandom()
  //  which doesn't require that an ordered chain of coroutine threads be set up
  corPlayer0.init(0, "cor_player0", cor, lock, CC.IS_NOT_HEAD);
  CoroutineController corPlayer1;
  corPlayer1.init(1, "cor_player1", cor, lock, CC.IS_NOT_HEAD);
  CoroutineController corPlayer2;
  corPlayer2.init(2, "cor_player2", cor, lock, CC.IS_NOT_HEAD);
  CoroutineController corPlayer3;
  corPlayer3.init(3, "cor_player3", cor, lock, CC.IS_NOT_HEAD);

  InCPlayer player0;
  player0.init("player0", seqs0, startEvent, stepEvent,
               corPlayer0, clock.stepDur, conductor, instr0);
  InCPlayer player1;
  player1.init("player1", seqs1, startEvent, stepEvent,
               corPlayer1, clock.stepDur, conductor, instr1);
  InCPlayer player2;
  player2.init("player2", seqs2, startEvent, stepEvent,
               corPlayer2, clock.stepDur, conductor, instr2);
  InCPlayer player3;
  player2.init("player3", seqs3, startEvent, stepEvent,
               corPlayer3, clock.stepDur, conductor, instr3);

  // start clock thread and instrument play threads
  spork ~ runClock(clock);
  spork ~ runPlayer(player0);
  spork ~ runPlayer(player1);
  spork ~ runPlayer(player2);
  spork ~ runPlayer(player3);

  while (true) {1::second => now;}  // block process exit to force child threads to run
}

main();

