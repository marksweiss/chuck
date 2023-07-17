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
  /* conf.addFloatArg("modulateVibratoGain", 0.2); */
  /* conf.addFloatArg("modulateRandomGain", 0.0); */
  /* conf.addDurationArg("delayDelay", 35::ms); */
  /* conf.addDurationArg("delayMax", 70::ms); */
  /* conf.addDurationArg("echoDelay", 10::ms); */
  /* conf.addDurationArg("echoMax", 20::ms); */
  /* conf.addFloatArg("echoMix", 0.15); */
  conf.addFloatArg("reverbMix", 0.05);
  conf.loadArgs();

  return conf;
}

// TODO
// - Look at other UGens, work on better timbres for composition
// - Experiment with micro-detune, (see detune example in book)
// - JUST INTONATION!!!
// - Dynamic signal processing example from Chuck book, Chapter 8
// - Cleanup
//   - move In C stuff into it's own directory
fun void main () {
  // init clock, tempo and time advance Events
  10 => int NUM_PHRASES;
  2 => int NUM_PLAYERS;

  40 => int BPM;
  Event startEvent;
  Event stepEvent; 

  Clock clock;
  clock.init(BPM, startEvent, stepEvent);

  // For passing a copy of the initial, unmodified source sequences to the Conductor
  // so it can advance players to a clean copy of the next sequences, or undo changes
  // to the player copy of a sequence
  // sequences are not looping -- when we get to last phrase we end
  false => int isLooping;
  Sequences seqs0;
  seqs0.init("seqs0", isLooping);
  Sequences seqs1;
  seqs1.init("seqs1", isLooping);
  [seqs0, seqs1] @=> Sequences seqs[];

  InCHelper helper;
  helper.getScore(BPM, seqs);

  // configure instruments, pass clock, Events, sequences of phrases and conductor to them 
  getConf(300, 20::ms, 10::ms, 20::ms) @=> ArgParser conf0;
  getConf(150, 20::ms, 20::ms, 20::ms) @=> ArgParser conf1;

  InstrSqrOsc instr0;
  0.0 => float phase;
  0.4 => float width; 
  instr0.init("instr0", phase, width, conf0);

  InstrSqrOsc instr1; 
  0.0 => phase;
  0.0 => width; 
  instr1.init("instr1", phase, width, conf1);
  
  // create patch chain
  // always precede dac with Gain, because Gain goes out of scope when code stops running,
  // breaking Ugen connection to dac output, but dac does not without explicit use of =< operator.
  // See: https://learning.oreilly.com/library/view/programming-for-musicians/9781617291708/OEBPS/Text/kindle_split_018.html 
  instr0.osc => instr0.chorus => instr0.echo => instr0.delay => instr0.rev => instr0.pan => instr0.env => instr0.g;
  instr1.osc => instr1.chorus => instr1.echo => instr1.delay => instr1.rev => instr1.pan => instr1.env => instr1.g;
  instr0.g => dac.right; 
  instr1.g => dac.left; 

  // global coordinator of interprocess state governing composition behavior, such
  // as in this case whether instruments move to the next phrase or stay on the current one
  0 => int id;
  NoteConst N;
  helper.makePhrase([N.B4_16, N.G4_16], id) @=> Sequence lastPhrase;
  InCConductor conductor;
  conductor.init(NUM_PHRASES, NUM_PLAYERS, seqs0, lastPhrase);

  // declare the Players whose behavior governed by calling the Conductor to
  // to check their state changes, performing the notes of the Sequences using the
  // Instruments to play the notes
  CoroutineController CC;
  Coroutine cor;
  Lock lock;
  // TODO init() overload that doesn't require IS_NOT_HEAD / IS_HEAD because now support signalRandom()
  //  which doesn't require that an ordered chain of coroutine threads be set up
  CoroutineController corPlayer0;
  corPlayer0.init(0, "cor_player0", cor, lock, CC.IS_NOT_HEAD);
  CoroutineController corPlayer1;
  corPlayer1.init(1, "cor_player1", cor, lock, CC.IS_NOT_HEAD);

  InCPlayer player0;
  player0.init("sqrosc player0", seqs0, startEvent, stepEvent,
               corPlayer0, clock.stepDur, conductor, instr0);
  InCPlayer player1;
  player1.init("sqrosc player1", seqs1, startEvent, stepEvent,
               corPlayer1, clock.stepDur, conductor, instr1);

  // start clock thread and instrument play threads
  spork ~ runClock(clock);
  spork ~ runPlayer(player0);
  spork ~ runPlayer(player1);

  while (true) {1::second => now;}  // block process exit to force child threads to run
}

main();

