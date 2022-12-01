// Machine.add("lib/arg_parser/arg_base.ck"); 
// Machine.add("lib/arg_parser/float_arg.ck"); 
// Machine.add("lib/arg_parser/int_arg.ck"); 
// Machine.add("lib/collection/arg_map.ck"); 
// Machine.add("lib/comp/conductor.ck"); 

public class InCConductor extends Conductor {
  OrderedArgMap settings; 

  // PLAYER SETTINGS

  "NUM_PHRASES" => string NUM_PHRASES;
  settings.put(IntArg.make(NUM_PHRASES, 53));
  
  // The most important factor governing advance of Players through phrases, this is simply
  // the percentage prob that they advance on any given iteration  
  "PHRASE_ADVANCE" => string PHRASE_ADVANCE;
  "PHRASE_ADVANCE_PROB" => string PHRASE_ADVANCE_PROB;
  // assumes range [0, 100), i.e. this advances 28% of the time
  settings.put(IntArg.make(PHRASE_ADVANCE_PROB, 28));

  // Player Phrase Phase 
  // Tunable parms for shifting playing of current phrase out of its current
  // phase, and also to shift it more in alignment.  Shift simple pre-pends
  // a rest Note to current phrase before writing it to Score.  Supports
  // score directive to adjust phase, and another to move in and out of phase
  // during a performance
  
  // Percentage prob that a Player will adjust phase on any given iteration
  "ADJ_PHASE_PROB_FACTOR" => string ADJ_PHASE_PROB_FACTOR:
  settings.put(IntArg.make(ADJ_PHASE_PROB_FACTOR, 7));
  // Supports Instruction that Player this is too often in alignment should favor
  // trying to be out of phase a bit more. If Player hasn't adjusted phase
  // this many times or more, then adj_phase_prob_increase_factor will be applied
  "ADJ_PHASE_COUNT_THRESHOLD" => string ADJ_PHASE_COUNT_THRESHOLD;
  settings.put(IntArg.make(ADJ_PHASE_COUNT_THRESHOLD, 1));
  "ADJ_PHASE_PROB_INCREASE_FACTOR" => string ADJ_PHASE_PROB_INCREASE_FACTOR;
  settings.put(IntArg.make(ADJ_PHASE_PROB_INCREASE_FACTOR, 2));
  // The length of the rest Note (in seconds) inserted if a Player is adjusting its phase  
  "PHASE_ADJ_DUR" => string PHASE_ADJ_DUR;
  settings.put(IntArg.make(PHASE_ADJ_DUR, 55));
  // Prob that a Player will seek unison on any given iteration.  The idea is that
  // to seek unison the Ensemble and all the Players must seek unison  
  "UNISON_PROB_FACTOR" => string UNISON_PROB_FACTOR;
  settings.put(IntArg.make(UNISON_PROB_FACTOR, 95));

  // Player Rest/Play
  // Tunable parms for probability that Player will rest rather than playing a note.
  // Supports score directive to listen as well as play and not always play
  // Prob that a Player will try to rest on a given iteration (not play)
  "REST_PROB_FACTOR" => string REST_PROB_FACTOR; 
  settings.put(IntArg.make(REST_PROB_FACTOR, 10));
  // Factor multiplied by rest_prob_factor if the Player is already at rest  
  "STAY_AT_REST_PROB_FACTOR" => string STAY_AT_REST_PROB_FACTOR;
  settings.put(FloatArg.make(STAY_AT_REST_PROB_FACTOR, 1.5));
  
  // Player Volume Adjusment, De/Crescendo
  // Tunable parms for adjusting volume up and down, and prob of making
  //  an amp adjustment. Supports score directive to have crescendos and
  //  decrescendos in the performance  

  // Threshold for the ratio of this Players average amp for its current phrase
  //  to the max average amp among all the Players. Ratio above/below this means the Player
  //  will raise/lower its amp by amp_de/crescendo_adj_factor    
  "AMP_ADJ_CRESCENDO_RATIO_THRESHOLD" => string AMP_ADJ_CRESCENDO_RATIO_THRESHOLD;
  settings.put(IntArg.make(AMP_ADJ_CRESCENDO_RATIO_THRESHOLD, 80));
  "AMP_CRESCENDO_ADJ_FACTOR" => string AMP_CRESCENDO_ADJ_FACTOR;
  settings.put(FloatArg.make(AMP_CRESCENDO_ADJ_FACTOR, 1.1));
  "AMP_ADJ_DIMINUENDO_RATIO_THRESHOLD" => AMP_ADJ_DIMINUENDO_RATIO_THRESHOLD;
  settings.put(FloatArg.make(AMP_ADJ_DIMINUENDO_RATIO_THRESHOLD, 1.2));
  "AMP_DIMINUENDO_ADJ_FACTOR" => AMP_DIMINUENDO_ADJ_FACTOR;
  settings.put(IntArg.make(AMP_DIMINUENDO_ADJ_FACTOR, 90));
  // Prob that a Player is seeking de/crescendo  
  "CRESCENDO_PROB_FACTOR" => string CRESCENDO_PROB_FACTOR;
  settings.put(IntArg.make(CRESCENDO_PROB_FACTOR, 50));
  "DIMINUENDO_PROB_FACTOR" => DIMINUENDO_PROB_FACTOR;
  settings.put(IntArg.make(DIMINUENDO_PROB_FACTOR, 50));
  
  // Player Transpose
  // Tunable parms for transposing the playing of a phrase.  Suppports score directive
  //  to transpose as desired.
  // Prob that a Player will seek to transpose its current phrase
  "TRANSPOSE_PROB_FACTOR" => string TRANSPOSE_PROB_FACTOR;
  settings.put(IntArg.make(TRANSPOSE_PROB_FACTOR, 20));
  // Number of octaves to transpose if the Player does do so
  // Amount that represents the number of semitones to shift, e.g. 12 for one octave
  "TRANSPOSE_SHIFT" => string TRANSPOSE_SHIFT; 
  settings.put(FloatArg.make(TRANSPOSE_SHIFT, 1.0));
  // Sadly, we need this also, because CSound is float type and MIDI is int type (0.0 or 0)
  "TRANSPOSE_NO_SHIFT" => string TRANSPOSE_NO_SHIFT;
  settings.put(FloatArg.make(TRANSPOSE_NO_SHIFT, 0.0));
  // Factor for shift down
  "TRANSPOSE_SHIFT_DOWN_FACTOR" => string TRANSPOSE_SHIFT_DOWN_FACTOR;
  settings.put(IntArg.make(TRANSPOSE_SHIFT_DOWN_FACTOR, -1.0));
  // Factor for shift up, likewise (1.0 in CSound, 1 in MIDI)
  "TRANSPOSE_SHIFT_UP_FACTOR" => string TRANSPOSE_SHIFT_UP_FACTOR;  
  settings.put(FloatArg.make(TRANSPOSE_SHIFT_UP_FACTOR, 1.0));
  // From the Instructions: "Transposing down by octaves works best on the patterns containing notes of long durations."
  // Minimum average duration of notes in a phrase for that phrase to be more likely
  //  to transpose down rather than up
  "TRANSPOSE_DOWN_PROB_FACTOR" => string TRANSPOSE_DOWN_PROB_FACTOR;
  settings.put(IntArg.make(TRANSPOSE_DOWN_PROB_FACTOR, 50));
  // Minimum average duration of notes in a phrase for that phrase to be more likely
  //  to transpose down rather than up  
  "TRANSPOSE_DOWN_DUR_THRESHOLD" => string TRANSPOSE_DOWN_DUR_THRESHOLD;
  settings.put(FloatArg.make(TRANSPOSE_DOWN_DUR_THRESHOLD, 2.0));

  // /PLAYER SETTINGS


  // ENSEMBLE SETTINGS

  // /ENSEMBLE SETTINGS

  
  // Override
  fun void update(int shredId) {
    isAdvancing(shredId);
  }

  // Override
  fun void updateAll() {
    for (0 => int i; i < this.shredSize(); i++) {
      update(this.shredIds[i]);
    }
  }

  // RULES IMPLEMENTATION

  fun /*private*/ void isAdvancing(int shredId) {
    if (exceedsThreshold(settings.get(PHRASE_ADVANCE_PROB))) {
      this.put(shredId, PHRASE_ADVANCE, true); 
    } else {
      this.put(shredId, PHRASE_ADVANCE, false); 
    }
  }
}
