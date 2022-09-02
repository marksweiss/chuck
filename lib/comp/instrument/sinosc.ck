// Machine.add("lib/comp/instrument/instrument.ck")

public class SinOsc extends Instrument {
  SinOsc so => Gain g => dac;
  false => bool convertPitchToFreq;

  fun void help() {
    <<< "Args:\n'gain' - float - [0.0..1.0]" >>>;
    <<< "Usage: Expects Notes to have freq set. To use with pitch pass '--pitch = true' arg" >>>;
  }

  fun void configure(ArgParser conf) {
    conf["--gain"].floatVal => g.gain;
    if cont.hasArg("pitch") {
      true => convertPitchToFreq;
    }
  }

  fun void play() {
    if (convertPitchToFreq) {
      playConvertingPitch();
    }

    0 => int i;
    while (true) {
      so.freq(notes[i].freq); 
      notes[i].gain => g.gain;
      notes[i].duration => now;
      (i + 1) % numNotes => i;
    }
  }

  // To avoid an extra if check on every note play
  fun void playConvertingPitch() {
    0 => int i;
    while (true) {
      so.freq(Std.mtof(notes[i].pitch)); 
      notes[i].gain => g.gain;
      notes[i].duration => now;
      (i + 1) % numNotes => i;
    }
  }
}
