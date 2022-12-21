// Machine.add("lib/arg_parser/arg_base.ck"); 
// Machine.add("lib/arg_parser/float_arg.ck"); 
// Machine.add("lib/arg_parser/int_arg.ck"); 
// Machine.add("lib/collection/arg_map.ck");
// Machine.add("lib/comp/note_const.ck"); 
// Machine.add("lib/comp/conductor.ck"); 
// Machine.add("lib/test/assert.ck"); 

// NOTES and Questions From Previous Implementation
// https://github.com/marksweiss/aleatoric/blob/master/compositions/Terry_Riley-In_C/midi/In_C_midi_user_instruction.rb 
// Pre play rules and Post play rules - do we need this?
// Players hold their own state
// Ensemble holds its own state and can check Players' state, some of it state
//  is derived from checking Players' state
// Separate "business logic" implentations of the rules execute rule logic against
//  Player and Ensemble state and determine whether:
//  - Player advances
//  - Player prepends a Rest note
//  - Player raises or lowers volume or goes silent, itself to "listen" or with group
//    logic orchestrated by the Ensemble if going into crescendo / descrescendo
//  - Player improvises

// RULES IMPLEMENTATION

// TODO HANDLE THE has_advanced logic in the original code by just calling all the predicates in
// a cascade and handle early exit on should advance, should be encapsulated from Player

public class InCConductor extends Conductor {

  // *******************
  // PLAYER SETTINGS
  // *******************
  Note N;
  OrderedArgMap settings; 

  // *******************
  // State Keys for Player Settings
  "PHRASE_IDX" => string PHRASE_IDX; 
  "GAIN" => string GAIN;
  "PLAYER_HAS_REACHED_UNISON" => string PLAYER_HAS_REACHED_UNISON;
  "PLAYER_HAS_ADVANCED" => string PLAYER_HAS_ADVANCED;
  "PLAYER_REACHED_LAST_PHRASE" => string PLAYER_REACHED_LAST_PHRASE;
  "PLAYER_PHRASE_PLAY_COUNT" => string PLAYER_PHRASE_PLAY_COUNT; 

  // *******************
  // State Keys for Ensemble Settings
  "ALL_PLAYERS_REACHED_UNISON" => string ALL_PLAYERS_REACHED_UNISON;
  "ALL_PLAYERS_REACHED_CONCLUSION" => string ALL_PLAYERS_REACHED_CONCLUSION;
  "ALL_PLAYERS_REACHED_CONCLUDING_UNISON" => string ALL_PLAYERS_REACHED_CONCLUDING_UNISON; 
  
  // *******************
  // Settings constants
  "NUM_PHRASES" => string NUM_PHRASES;
  settings.put(IntArg.make(NUM_PHRASES, 53));
 
  // Player must play each phrase at least this long
  // Insures that short phrases are played enough to counterpoint with longer phrases
  "MIN_REPEAT_PHRASE_DURATION" => string  MIN_REPEAT_PHRASE_DURATION;
  settings.put(FloatArg.make(MIN_REPEAT_PHRASE_DURATION, 2.0 * N.REST_1));

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
  "UNISON_PROB" => string UNISON_PROB;
  settings.put(IntArg.make(UNISON_PROB, 95));

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
  "CRESCENDO_PROB" => string CRESCENDO_PROB;
  settings.put(IntArg.make(CRESCENDO_PROB, 50));
  "DIMINUENDO_PROB" => DIMINUENDO_PROB;
  settings.put(IntArg.make(DIMINUENDO_PROB, 50));
  
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


  // *******************
  // ENSEMBLE SETTINGS
  // *******************

  "NUM_PLAYERS" => string NUM_PLAYERS;
  3 => NUM_PLAYERS;  
  // Threshold number of phrases behind the furthest ahead any Player is allowed to slip.
  // If they are more than 3 behind the leader, they must advance.     
  "PHRASES_IDX_RANGE_THRESHOLD" => string PHRASES_IDX_RANGE_THRESHOLD;
  3 => int PHRASES_IDX_RANGE_THRESHOLD;
  // Prob that the Ensemble will seek to have all Players play the same phrase
  // on any one iteration
  "UNISON_PROB" => string UNISON_PROB;
  20 => int UNISON_PROB;
  // Threshold number of phrases apart within which all players 
  // must be for Ensemble to seek unison
  "MAX_PHRASES_IDX_RANGE_FOR_SEEKING_UNISON" => string MAX_PHRASES_IDX_RANGE_FOR_SEEKING_UNISON;
  3 => int MAX_PHRASES_IDX_RANGE_FOR_SEEKING_UNISON;
  // Probability that the ensemble will de/crescendo in a unison (may be buggy)
  // TODO: bug is that code to build up crescendo over successive iterations isn't there
  // and instead this just jumps the amplitude jarringly on one iteration
  "CRESCENDO_PROB" => string CRESCENDO_PROB;
  0 => int CRESCENDO_PROB;
  "DIMINUENDO_PROB" => string DIMINUENDO_PROB;
  0 => int DIMINUENDO_PROB;
  // Maximum de/increase in volume (in CSound scale) that notes can gain in crescendo 
  // pursued during a unison or in the final Conclusion
  "MAX_AMP_RANGE_FOR_SEEKING_CRESCENDO" => string MAX_AMP_RANGE_FOR_SEEKING_CRESCENDO;
  20 => int MAX_AMP_RANGE_FOR_SEEKING_CRESCENDO;
  "MAX_AMP_RANGE_FOR_SEEKING_DIMINUENDO" => string MAX_AMP_RANGE_FOR_SEEKING_DIMINUENDO;
  20 => int MAX_AMP_RANGE_FOR_SEEKING_DIMINUENDO;
  // Parameters governing the Conclusion
  // This is the ratio of steps in the Conclusion to the total steps before the Conclusion  
  "CONCLUSION_STEPS_RATIO" => string CONCLUSION_STEPS_RATIO;
  0.1 => float CONCLUSION_STEPS_RATIO;
  // This extends the duration of the repetition of the last phrase
  // during the final coda.  At the start of the coda each player
  // has its start time pushed ahead to be closer to the maximum
  // so that they arrive at the end closer together.  This factor offsets the Player from
  // repeating the last phrase until exactly reaching the Conclusion  
  "CONCLUSION_CUR_START_OFFSET_FACTOR" => string CONCLUSION_CUR_START_OFFSET_FACTOR;
  0.05 => float CONCLUSION_CUR_START_OFFSET_FACTOR;
  // Maximum number of crescendo and decrescendo steps in the conclusion, supporting the 
  // Instruction indicating ensemble should de/crescendo "several times"
  "MAX_NUMBER_CONCLUDING_CRESCENDOS" => string MAX_NUMBER_CONCLUDING_CRESCENDOS;
  4 => int MAX_NUMBER_CONCLUDING_CRESCENDOS;

  // /ENSEMBLE SETTINGS

 
  // *******************
  // API
  // *******************
 
  // Override
  fun void update(int shredId) {
    /* isAdvancing(shredId); */
  }

  // Override
  fun void updateAll() {
    for (0 => int i; i < this.shredSize(); i++) {
      update(this.shredIds[i]);
    }
  }

  // *******************
  // INSTRUCTIONS
  // *******************

  // *******************
  // No-op Instructions

  // "All performers play from the same page of 53 melodic patterns played in sequence."
  // "Any number of any kind of instruments can play.  A group of about 35 is desired if possible but smaller or larger groups will work.  If vocalist(s) join in they can use any vowel and consonant sounds they like."
  // "The tempo is left to the discretion of the performers, obviously not too slow, but not faster than performers can comfortably play."
  // "If for some reason a pattern can’t be played, the performer should omit it and go on."
  // "Instruments can be amplified if desired.  Electronic keyboards are welcome also."

  // Player Pre-play Performance Instructions

  // "Patterns are to be played consecutively with each performer having the freedom to determine how many 
  //  times he or she will repeat each pattern before moving on to the next.  There is no fixed rule 
  //  as to the number of repetitions a pattern may have, however, since performances normally average 
  //  between 45 minutes and an hour and a half, it can be assumed that one would repeat each pattern 
  //  from somewhere between 45 seconds and a minute and a half or longer."
  fun instruction10(int playerId) {
    if (seekingUnison(playerId)) {
      put(playerId, PHRASE_IDX, get(playerId, PHRASE_IDX) + 1));
      put(playerId, PLAYER_HAS_ADVANCED, true);
      put(playerId, PLAYER_HAS_REACHED_UNISON, true);
    }
  }

  // TODO OTHER PRE-PLAY
  // THEN PLAY NOTES
  // THEN PUT STATE BASED ON PRE-PLAY CHANGES, esp. ENSEMBLE STATE BASED ON ALL PLAYERS

  // *******************
  // INSTRUCTION HELPERS
  // *******************

  fun int reachedLastPhrase(int playerId) {
    phraseIdx(playerId) == NUM_PHRASES - 1;
  }

  fun int advancePhraseIdx(int playerId) {
    return !reachedLastPhrase(playerId) && exceedsThreshold(settings.PHRASE_ADVANCE_PROB);
  }

  fun int advancePhraseIdxTooFarBehind(int playerId) {
    return getAllMaxInt(PHRASE_IDX) - phraseIdx(playerId) > settings.PHRASES_IDX_RANGE_THRESHOLD;
  }

  fun int repeatCurPhrase(Sequence seq, int curPhrasePlayCount) {
    float seqDuration;
    Chord chord;
    while (seq.next() != null) {
      seqDuration += seq.current().notes[0].duration;
    }
    return curPhrasePlayCount * seqDuration < settings.MIN_REPEAT_PHRASE_DURATION
  }

  fun int seekingUnison(int playerId) {
    playersPhraseIdxRange() < settings.MAX_PHRASES_IDX_RANGE_FOR_SEEKING_UNISON => int inRange;
    return inRange && exceedsThreshold(setttings.UNISON_PROB);
  }

  fun int seekingCrescendo(int playerId) {
    ampRange() => float curAmpRange;
    assertFloatLessThan(ampRange, settings.MAX_AMP_RANGE_FOR_SEEKING_CRESCENDO) => int ampInMaxRange;
    return ampInMaxRange && exceedsThreshold(settings.CRESCENDO_PROB);
  }
 
  fun int seekingDiminuendo(int playerId) {
    ampRange() => float curAmpRange;
    assertFloatLessThan(ampRange, settings.MAX_AMP_RANGE_FOR_SEEKING_DIMINUENDO) => int ampInMaxRange;
    return ampInMaxRange && exceedsThreshold(settings.DIMINUENDO_PROB);
  }
 
  fun /*private*/ float ampRange() {
    return getAllMaxFlt(GAIN) - getAllMinFlt(GAIN);  
  }
 
  fun /*private*/ int phraseIdx(int playerId) {
    return get(playerId, PHRASE_IDX);
  }

  fun /*private*/ int playersPhraseIdxRange() {
    return getAllMaxInt(PHRASE_IDX) - getAllMinInt(PHRASE_IDX);
  }
} 
