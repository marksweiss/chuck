
fun void main() {
  SinOsc so1 => Gain g => PRCRev rvb => dac;
  SinOsc so2 => g;
  SinOsc so3 => g;
  SinOsc so4 => g;
  0.5 => rvb.gain;
  0.25 => rvb.mix;

  261.63 => float C4;
  C4 => so1.freq;
  C4 => so2.freq;
  C4 => so3.freq;
  C4 => so4.freq;
  
  12 => int CYCLE_LEN;
  0 => int i;
  2.5 => float FREQ_STEP;
  while (true) {
    1::samp => now;
    C4 + (i * FREQ_STEP) => so2.freq;
    C4 + (i * 2 * FREQ_STEP) => so3.freq;
    C4 + (i * 0.5 * FREQ_STEP) => so4.freq;
    (i + 1) % CYCLE_LEN => i;
    0.25 + (.05 * (i % CYCLE_LEN)) => rvb.mix;
  }

  // args
  /* ArgParser argParser; */
  /* argParser.addIntArg("controllerPortIn", 0) @=> IntArg controllerPortIn; */
}

main();
