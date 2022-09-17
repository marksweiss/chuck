// cli: $> chuck lib/arg_parser/arg_base.ck lib/arg_parser/int_arg.ck \
//               lib/arg_parser/float_arg.ck lib/arg_parser/string_arg.ck \
//               lib/arg_parser/arg_parser.ck lib/comp/scale.ck lib/comp/note.ck \
//               lib/comp/chord.ck lib/comp/instrument/instrument.ck lib/comp/clock.ck
//               lib/comp/instrument/sinosc.ck

// For client to spork, which requires a free function as entry point
public void playClock(Clock clock) {
  <<< "IN playClock" >>>;

  clock.play();
}

// For client to spork, which requires a free function as entry point
public void playInstrSinOsc(InstrSinOsc instr) {
  <<< "IN playInstr" >>>;

  instr.play();
}

// TODO Instr only has one UGen, paired with gain and event loop
// TODO GET RID OF NUM PLAYERS ETC. in base class
// Then we can compose by having instruments chain to each other and then to output
public class InstrSinOsc extends Instrument {
  // ugen setup
  Gain g;
  SinOsc so => g => dac;
  // args specific to this instr
  "--gain" => string ARG_GAIN;
  // events
  Event startEvent;
  Event stepEvent;
  dur stepDur;

  fun void init(ArgParser conf, Event startEvent, Event stepEvent, dur stepDur) {
    for (0 => int i; i < DEFAULT_NUM_PLAYERS + 1; ++i) {
      conf.args[ARG_GAIN].fltVal => g.gain;
    }
    startEvent @=> this.startEvent;    
    stepEvent @=> this.stepEvent;    
    stepDur => this.stepDur;
  }

  fun void instrHelp() {
    <<< "Args:\n'gain' - float - [0.0..1.0]" >>>;
  }

  fun void play() {
    // block on START
    startEvent => now;

    0 => int i;
    0::samp => dur sinceLastNote;
    while (true) {
      // get next note to play
      chords[i] @=> Chord c;

      /* <<< "IN INSTR TOP OF LOOP on chord index:", i, "Chord", c >>>; */

      // TODO THIS IS THE BUG WE NEED TEMPO HERE, BPM-ADJUSTED
      // TODO assumes all notes in chord have same duration
      c.notes[0].duration => dur nextNoteDur;

      // block on event of next beat step broadcast by clock
      stepEvent => now;
      sinceLastNote + stepDur => sinceLastNote; 

      /* <<< "IN INSTR BEFORE Note dur equaled, now:", now, "sinceLastNote:", sinceLastNote, "nextNoteDur:", nextNoteDur >>>; */

      // if enough time has passed, emit the next note, silence the previous note
      // TODO support turning off notes of any duration, not just one coninous chain of
      // notes of the same duration
      if (sinceLastNote == nextNoteDur) {

        <<< "IN INSTR Note dur equaled, sinceLastNote:", sinceLastNote, "nextNoteDur:", nextNoteDur >>>;
        Scale s;

        for (0 => int j; j < c.notes.cap(); j++) {
          c.notes[j] @=> Note n;
          
         <<< "IN INSTR note gain", n.gain >>>; 

          /* <<< "IN INSTR NOTE BEING ADDED name:", n.name, "pitch:", s.pitchName(n.pitch) >>>; */

          // TODO float freq support
          so.freq(Std.mtof(n.pitch)); 
          n.gain => g.gain;

          /* <<< "IN INSTR Note emitted at Note index:", i >>>; */
        }

        0::samp => sinceLastNote;
        (i + 1) % numChords => i;
        /* <<< "IN INSTR on chord index:", i >>>; */

        me.yield();
      }
    }
  }
}

fun void main () {
  <<< "--------------------------\nIN SINOSC MAIN, shred id:" >>>;

  240 => int BPM; 
  4 => int OCTAVE;
  0.75 => float GAIN;

  Event startEvent;
  Event stepEvent; 

  Clock clock;
  clock.init(BPM, startEvent, stepEvent);

  clock.D(0.25) => dur QRTR;
  /* clock.quarter() => dur QRTR; */

  <<< "IN SINOSC MAIN QUARTER_DUR", QRTR >>>;

  InstrSinOsc instr;
  ArgParser conf;
  conf.addFloatArg("gain", GAIN);
  conf.loadArgs();
  instr.init(conf, startEvent, stepEvent, clock.stepDur);

  <<< "IN SINOSC MAIN AFTER INSTR.INIT()" >>>;

  Chord c;
  Scale s;
  Chord chords[4];
  c.make(s.triad(OCTAVE, s.C, s.M), GAIN * 0.8, QRTR) @=> Chord CMaj;
  c.make(s.triad(OCTAVE, s.F, s.m), GAIN, QRTR) @=> Chord FMin;
  c.make(s.triad(OCTAVE + 1, s.G, s.M), GAIN * 0.8, QRTR) @=> Chord GMaj;
  c.make(s.triad(OCTAVE, s.C, s.M), 0.0, QRTR) @=> Chord CMaj_Rest;
  CMaj @=> chords[0];
  FMin @=> chords[1];
  GMaj @=> chords[2];
  CMaj_Rest @=> chords[3];
  instr.addChords(chords);

  <<< "IN SINOSC MAIN AFTER SYNC BEFORE SPORK" >>>;

  spork ~ playClock(clock);
  spork ~ playInstrSinOsc(instr);

  <<< "IN SINOSC MAIN AFTER SPORK" >>>;
 
  me.yield();  // yield to Clock and Instrument event loops 
  while (true) {1::second => now;}  // block process exit to force child threads to run
}

main();
