// Machine.add("lib/arg_parser/arg_base.ck"); 
// Machine.add("lib/arg_parser/float_arg.ck"); 
// Machine.add("lib/arg_parser/int_arg.ck"); 
// Machine.add("lib/collection/arg_map.ck");
// Machine.add("lib/collection/object_map.ck");
// Machine.add("lib/comp/clock.ck"); 
// Machine.add("lib/comp/note.ck"); 
// Machine.add("lib/comp/note_const.ck"); 
// Machine.add("lib/comp/chord.ck"); 
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
  Clock K;
  OrderedArgMap settings;
  OrderedObjectMap playerPhraseMap;
  int concludingCrescendoGainAdjustments[1];
  int concludingDecrescendoGainAdjustments[1];

  // *******************
  // State Keys for Player Settings
  "PHRASE_IDX" => string PHRASE_IDX; 
  // TOOD DO WE NEED 'GAIN' IN STATE? PROBABLY NOT SINCE WE ARE NOW SETTING NOTE VALUES DIRECTLY HERE
  "GAIN" => string GAIN;
  "PLAYER_HAS_REACHED_UNISON" => string PLAYER_HAS_REACHED_UNISON;
  "PLAYER_HAS_ADVANCED" => string PLAYER_HAS_ADVANCED;
  "PLAYER_REACHED_LAST_PHRASE" => string PLAYER_REACHED_LAST_PHRASE;
  "PLAYER_PHRASE_PLAY_COUNT" => string PLAYER_PHRASE_PLAY_COUNT; 
  "PLAYER_AT_REST" => string PLAYER_AT_REST;
  "PLAYER_ADJ_PHASE_COUNT" => string PLAYER_ADJ_PHASE_COUNT; 
  "PLAYER_LAST_PHRASE_BEFORE_CRESCENDO_PLAY_COUNT" => string PLAYER_LAST_PHRASE_BEFORE_CRESCENDO_PLAY_COUNT; 
  "PLAYER_LAST_PHRASE_CRESCENDO_PLAY_COUNT" => string PLAYER_LAST_PHRASE_CRESCENDO_PLAY_COUNT; 
  "PLAYER_HAS_STOPPED" => strin PLAYER_HAS_STOPPED;

  // *******************
  // State Keys for Ensemble Settings
  "NUM_PLAYERS" => string NUM_PLAYERS;
  "NUM_PHRASES" => string NUM_PHRASES;
  "ALL_PLAYERS_REACHED_UNISON" => string ALL_PLAYERS_REACHED_UNISON;
  "ALL_PLAYERS_REACHED_CONCLUSION" => string ALL_PLAYERS_REACHED_CONCLUSION;
  "ALL_PLAYERS_REACHED_CONCLUDING_UNISON" => string ALL_PLAYERS_REACHED_CONCLUDING_UNISON; 
  "NUM_PLAYS_BEFORE_CONCLUDING_CRESCENDOS" => string NUM_PLAYS_BEFORE_CONCLUDING_CRESCENDO;
  "NUM_CONCLUDING_CRESCENDOS" => string NUM_CONCLUDING_CRESCENDOS;
  "ALL_PLAYERS_STOPPED" => string ALL_PLAYERS_STOPPED;
  
  // *******************
  // Settings constants
  1.0 => float NO_FACTOR;
 
  // Player must play each phrase at least this long
  // Insures that short phrases are played enough to counterpoint with longer phrases
  "MIN_REPEAT_PHRASE_DURATION" => string  MIN_REPEAT_PHRASE_DURATION;
  settings.put(FloatArg.make(MIN_REPEAT_PHRASE_DURATION, 2.0 * N.REST_1));

  // The most important factor governing advance of Players through phrases, this is simply
  // the percentage prob that they advance on any given iteration  
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
  "ADJ_PHASE_PROB" => string ADJ_PHASE_PROB:
  settings.put(IntArg.make(ADJ_PHASE_PROB, 7));
  // Supports Instruction that Player this is too often in alignment should favor
  // trying to be out of phase a bit more. If Player hasn't adjusted phase
  // this many times or more, then adj_phase_prob_increase_factor will be applied
  "ADJ_PHASE_COUNT_THRESHOLD" => string ADJ_PHASE_COUNT_THRESHOLD;
  settings.put(IntArg.make(ADJ_PHASE_COUNT_THRESHOLD, 1));
  "ADJ_PHASE_PROB_INCREASE_FACTOR" => string ADJ_PHASE_PROB_INCREASE_FACTOR;
  settings.put(IntArg.make(ADJ_PHASE_PROB_INCREASE_FACTOR, 2));
  // The length of the rest Note (in seconds) inserted if a Player is adjusting its phase  
  K.QRTR => float PHASE_ADJ_NOTE_DUR;
  "PHASE_ADJ_DUR" => string PHASE_ADJ_DUR;
  settings.put(IntArg.make(PHASE_ADJ_DUR, PHASE_ADJ_NOTE_DUR));
  N.make(0, K.NO_GAIN, PHASE_ADJ_NOTE_DUR) @=> Note PHASE_ADJ_REST_NOTE;

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
  "GAIN_ADJ_CRESCENDO_RATIO_THRESHOLD" => string GAIN_ADJ_CRESCENDO_RATIO_THRESHOLD;
  settings.put(IntArg.make(GAIN_ADJ_CRESCENDO_RATIO_THRESHOLD, 80));
  "GAIN_CRESCENDO_ADJ_FACTOR" => string GAIN_CRESCENDO_ADJ_FACTOR;
  settings.put(FloatArg.make(GAIN_CRESCENDO_ADJ_FACTOR, 1.1));
  "GAIN_ADJ_DIMINUENDO_RATIO_THRESHOLD" => GAIN_ADJ_DIMINUENDO_RATIO_THRESHOLD;
  settings.put(FloatArg.make(GAIN_ADJ_DIMINUENDO_RATIO_THRESHOLD, 1.2));
  "GAIN_DIMINUENDO_ADJ_FACTOR" => GAIN_DIMINUENDO_ADJ_FACTOR;
  settings.put(IntArg.make(GAIN_DIMINUENDO_ADJ_FACTOR, 90));
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
  settings.put(FloatArg.make(TRANSPOSE_DOWN_DUR_THRESHOLD, 2::second));

  // /PLAYER SETTINGS

  // *******************
  // ENSEMBLE SETTINGS
  // *******************

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
  // TODO DO WE NEED THIS?
  /* "CONCLUSION_STEPS_RATIO" => string CONCLUSION_STEPS_RATIO; */
  /* 0.1 => float CONCLUSION_STEPS_RATIO; */
  // This extends the duration of the repetition of the last phrase
  // during the final coda.  At the start of the coda each player
  // has its start time pushed ahead to be closer to the maximum
  // so that they arrive at the end closer together.  This factor offsets the Player from
  // repeating the last phrase until exactly reaching the Conclusion  
  // TODO DO WE NEED THIS?
  /* "CONCLUSION_CUR_START_OFFSET_FACTOR" => string CONCLUSION_CUR_START_OFFSET_FACTOR; */
  /* 0.05 => float CONCLUSION_CUR_START_OFFSET_FACTOR; */
  // Maximum number of crescendo and decrescendo steps in the conclusion, supporting the 
  // Instruction indicating ensemble should de/crescendo "several times"
  "MIN_NUM_CONCLUDING_CRESCENDOS" => string MIN_NUM_CONCLUDING_CRESCENDOS;
  2 => int MAX_NUM_CONCLUDING_CRESCENDOS;
  "MAX_NUM_CONCLUDING_CRESCENDOS" => string MAX_NUM_CONCLUDING_CRESCENDOS;
  6 => int MAX_NUM_CONCLUDING_CRESCENDOS;
  "MIN_LAST_PHRASE_REPETITIONS_BEFORE_CONCLUSION" => string MIN_LAST_PHRASE_REPETITIONS_BEFORE_CONCLUSION;
  2 => int MIN_LAST_PHRASE_REPETITIONS_BEFORE_CONCLUSION;
  "MAX_LAST_PHRASE_REPETITIONS_BEFORE_CONCLUSION" => string MAX_LAST_PHRASE_REPETITIONS_BEFORE_CONCLUSION;
  4 => int MAX_LAST_PHRASE_REPETITIONS_BEFORE_CONCLUSION;

  // /ENSEMBLE SETTINGS

  fun void init(int numPhrases, int numPlayers, Sequence lastPhrase) {
    putGlobal(NUM_PHRASES, numPhrases);
    putGlobal(NUM_PLAYERS, numPlayers);

    // initialize global state for all Players
    putGlobal(settings.ALL_PLAYERS_REACHED_UNISON, false);
    putGlobal(settings.ALL_PLAYERS_REACHED_LAST_PHRASE, false);
    putGlobal(settings.ALL_PLAYERS_REACHED_LAST_PHRASE_UNISON, false);
    putGlobal(settings.ALL_PLAYERS_STOPPED, false);
    // set now to use in conclusion, number of repetitions of last phrase before concluding crescendo
    // and number of concluding crescendos
    putGlobal(settings.NUM_PLAYS_BEFORE_CONCLUDING_CRESCENDO,
              Math.random2(settings.MIN_LAST_PHRASE_REPETITIONS_BEFORE_CONCLUSION,
                           settings.MAX_LAST_PHRASE_REPETITIONS_BEFORE_CONCLUSION));

    Math.random2(settings.MIN_NUM_CONCLUDING_CRESCENDOS, settings.MAX_NUM_CONCLUDING_CRESCENDOS)) => int numCrescendos;
    // times 2 because each iteration by a player in the crescendo is either the crescendo up or
    // decrescendo back down, instruction handler uses % to know whether the sign the player should apply to gain
    putGlobal(settings.NUM_CONCLUDING_CRESCENDOS, 2 * numCrescendos);

    for (0 => int i; i < lastPhrase.size(); i++) {
      lastPhrase.chords[i].notes[0] @=> Note n;
      ((n.gain * GAIN_CRESCENDO_ADJ_FACTOR) - n.gain) / (numCrescendos $ float) => float chordCrescendoAdj;
      ((n.gain * GAIN_DIMINUENDO_ADJ_FACTOR) - n.gain) / (numCrescendos $ float) * -1.0 => float chordDecrescendoAdj;
      concludingCrescendoGainAdjustments << chordCrescendoAdj;
      concludingDecrescendoGainAdjustments << chordDecrescendoAdj;
    }
  }
 
  // *******************
  // API
  // *******************
 
  /**
   * Driver loop polls ALL_PLAYERS_STOPPED and ends process once it is true
   */
  // Override
  fun int isPlaying() {
    for (0 => int i; i < settings.NUM_PLAYERS;
    return !settings.ALL_PLAYERS_STOPPED;
  }

  // Override
  // TODO playerId vs. shredId semantics
  fun void update(int shredId) {
    // TODO SHOULD WE EVEN HAVE A BASE CLASS INTERFACE?
    // No-op

    // TODO CALL ALL THE INSTRUCTIONS
    /* isAdvancing(shredId); */
  }

  /**
   * Runs all update instructions based on current state for Player, all Players. Returns
   * either the input phrase in final updated form to play or, if the player advanced
   * to next phrase during the update, the next phrase in final updated form to play.
   */  
  fun Sequence update(int playerId, Sequence phrase) {
    playerPhraseMap.put(idToKey(playerId), phrase);
    // TODO CALL ALL THE INSTRUCTIONS
    // TODO RETURN THE FINAL UPDATED SEQUENCE TO PLAY ON THIS ITERATION
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
  // *******************

  // "All performers play from the same page of 53 melodic patterns played in sequence."

  // "Any number of any kind of instruments can play.  A group of about 35 is desired if possible
  //  but smaller or larger groups will work.  If vocalist(s) join in they can use any vowel and consonant sounds they like."

  // "The tempo is left to the discretion of the performers, obviously not too slow, but not faster than performers can
  //  comfortably play."

  // "If for some reason a pattern can’t be played, the performer should omit it and go on."

  // "Instruments can be amplified if desired.  Electronic keyboards are welcome also."

  // TODO IMPLEMENT PULSE
  // "The ensemble can be aided by the means of an eighth note pulse played on the high c’s of the piano or on a mallet instrument.  
  // It is also possible to use improvised percussion in strict rhythm (drum set, cymbals, bells, etc.), 
  //  if it is carefully done and doesn’t overpower the ensemble.  
  // All performers must play strictly in rhythm and it is essential that everyone play each pattern carefully"

  // TODO IMPLEMENT THIS
  // "It is important to think of patterns periodically so that when you are resting you are conscious of the larger 
  //  periodic composite accents that are sounding, and when you re-enter you are aware of what effect your entrance 
  //  will have on the music’s flow."

  // *******************
  // / No-op Instructions
  // *******************

  // *******************
  // Player Pre-play Performance Instructions
  // *******************
  // instruction business logic, call predicates and adjust player and player phrase state

  // "Patterns are to be played consecutively with each performer having the freedom to determine how many 
  //  times he or she will repeat each pattern before moving on to the next.  There is no fixed rule 
  //  as to the number of repetitions a pattern may have, however, since performances normally average 
  //  between 45 minutes and an hour and a half, it can be assumed that one would repeat each pattern 
  //  from somewhere between 45 seconds and a minute and a half or longer."
  fun void instructionAdvancePhraseIdx(int playerId) {
    if (!hasAdvanced(playerId) && advancePhraseIdx(playerId)) {
      increment(playerId, PHRASE_IDX);
      put(playerId, PLAYER_HAS_ADVANCED, true);
    }
  }

  //  "... As the performance progresses, performers should stay within 2 or 3 patterns of each other. ..."
  fun void instructionAdvancePhraseIdxTooFarBehind(int playerId) {
    if (!hasAdvanced(playerId) && tooFarBehind(playerId)) {
      increment(playerId, PHRASE_IDX);
      put(playerId, PLAYER_HAS_ADVANCED, true);
    }
  }

  // "The group should aim to merge into a unison at least once or twice during the performance ..."
  fun void instructionAdvancePhraseIdxSeekingUnison(int playerId) {
    if (!hasAdvanced(playerId) && seekingUnison(playerId)) {
      increment(playerId, PHRASE_IDX);
      put(playerId, PLAYER_HAS_ADVANCED, true);
      put(playerId, PLAYER_HAS_REACHED_UNISON, true);
    }
  }

  // "It is very important that performers listen very carefully to one another and this means occasionally to drop out
  //  and listen. ... As an ensemble, it is very desirable to play very softly as well as very loudly and to try to diminuendo
  //  and crescendo together."
  fun void instructionRestOrCrescendoDecrescendo(int playerId) {
    NO_FACTOR => float gainAdjFactor;
    if (rest(playerId)) {
      // TOOD DO WE NEED 'GAIN' IN STATE? PROBABLY NOT SINCE WE ARE NOW SETTING NOTE VALUES DIRECTLY HERE
      /* put(playerId, GAIN, 0.0); */
      0.0 => gainAdjFactor;
      put(playerId, PLAYER_AT_REST, true);
    } else {
      gainAdjFactor(playerId) => gainAdjFactor;
      put(playerId, PLAYER_AT_REST, false);
    }

    if (!assertFloatEqual(gainAdjFactor, NO_FACTOR) {
      phrase(playerId) => Sequence playerPhrase;
      // for each chord in the phrase
      for (0 => int i; i < playerPhrase.size(); i++) {
        playerPhrase[i] => Chord c;
        // for each note in the chord
        for (0 => int k; k < c.size(); k++) {
          // adjust the note's gain
          c[k].gain * gainAdjFactor => c[k].gain;
        } 
      }
      playerPhraseMap.put(idToKey(playerId), playerPhrase);
    }
  }

  // "Each pattern can be played in unison or canonically in any alignment with itself or with its neighboring patterns.  ..."
  // ... if the players seem to be consistently too much in the same alignment of a pattern, 
  //  they should try shifting their alignment by an eighth note or quarter note with what’s going on in the
  //  rest of the ensemble."
  fun void instructionChangeAlignment(int playerId) {
    if (adjustPhase(playerId)) {
      // copy the rest Note into a new Chord
      N.make(PHASE_ADJ_REST_NOTE) @=> Note phaseAdjRestNote;
      Chord phaseAdjRestChord;transposeShift
      phaseAdjRestChord.init(phaseAdjRestNote);

      // construct a new Sequence
      Sequence adjustedPhrase;
      adjustedPhrase.init(false);  // not looping
      // prepend the rest Chord into the new Sequence
      adjustedPhrase.add(phaseAdjRestChord);

      // get the current Phrase and append it into the adjusted phrase after the rest note
      phrase(playerId) @=> Sequence currentPhrase; 
      while (currentPhrase.next() != null) {
        adjustedPhrase.add(currentPhrase.current());
      }

      // replace the phrase state for the player with the new phrase with the new alignment
      playerPhraseMap.put(idToKey(playerId), adjustedPhrase);
    }
  }

  // "It is OK to transpose patterns by an octave, especially to transpose up.  Transposing down by octaves 
  //  works best on the patterns containing notes of long durations. 
  // TODO IMPLEMENT THIS Augmentation of rhythmic values can also be effective."
  fun void instructionTranspose(int playerId) {
    if (transpose(playerId)) {
      transposeShift(playerId) => float shift;

      phrase(playerId) @=> Sequence currentPhrase; 
      while (currentPhrase.next() != null) {
        currentPhrase.current() @=> Chord c;
        for (0 => int i; i < c.size(); i++) {
          c.notes[i].pitch += shift;
        }
      }
      playerPhraseMap.put(idToKey(playerId), currentPhrase);
    }
  }

  // "In C is ended in this way:  when each performer arrives at figure #53, he or she stays on it until the entire
  // ensemble has arrived there. The group then makes a large crescendo and diminuendo a few times and each player
  // drops out as he or she wishes." 
  fun void instructionConclusionCrescendoDescrescento(int playerId) {
    // check if this  Player has reached the last phrase and set state if it has
    if (!get(playerId, PLAYER_HAS_STOPPED) && reachedLastPhrase(playerId)) {
      put(playerId, settings.PLAYER_REACHED_LAST_PHRASE, true);

      // now check if all players have reached the last phrase
      ensembleReachedLastPhraseCrescendo() => int inLastPhraseCrescendo; 
      
      if (ensembleReachedLastPhrase() && !inLastPhraseCrescendo) {
        // if the player is endtering the last phrase for the first time, set its count state
        if (!hasKey(playerId, settings.PLAYER_LAST_PHRASE_BEFORE_CRESCENDO_PLAY_COUNT) {
          put(playerId, settings.PLAYER_LAST_PHRASE_BEFORE_CRESCENDO_PLAY_COUNT, 1);
        }
        // player is on the last phrase and not applying any gain change, so just play back the phrase no change
        get(playerId, settings.PLAYER_LAST_PHRASE_BEFORE_CRESCENDO_PLAY_COUNT) => int playCount;
        put(playerId, settings.PLAYER_LAST_PHRASE_BEFORE_CRESCENDO_PLAY_COUNT, playCount + 1);
        
      } else if (inLastPhraseCrescendo) {
        if (!hasKey(playerId, settings.PLAYER_LAST_PHRASE_CRESCENDO_PLAY_COUNT) {
          put(playerId, settings.PLAYER_LAST_PHRASE_BEFORE_CRESCENDO_PLAY_COUNT, 1);
        }
        get(playerId, settings.PLAYER_LAST_PHRASE_CRESCENDO_PLAY_COUNT) => int playCount;

        phrase(playerId) @=> Sequence currentPhrase; 
        // even iterations are crescendo, odd decrescendo
        // player is on a decrescendo this iteration, actually increment state that they
        // have completed a crescendo iteration
        if (playCount + 1 % 2 == 1) {
          for (0 => int i; i < concludingDecrescendoGainAdjustments.size(); i++) {
            concludingDecrescendoGainAdjustments.size[i] => float gainAdjFactor;  
            currentPhrase.chords[i] @=> Chord c;
            for (0 => int i; i < c.size(); i++) {
              c.notes[i].gain += gainAdjFactor;
            }
        } else {
          for (0 => int i; i < concludingCrescendoGainAdjustments.size(); i++) {
            concludingCrescendoGainAdjustments.size[i] => float gainAdjFactor;  
            currentPhrase.chords[i] @=> Chord c;
            for (0 => int i; i < c.size(); i++) {
              c.notes[i].gain += gainAdjFactor;
            }
          }
        }
        playerPhraseMap.put(idToKey(playerId), currentPhrase);
        put(playerId, settings.PLAYER_LAST_PHRASE_CRESCENDO_PLAY_COUNT, playCount++);
        
        // Set state for player being stopped if they have finished all crescendos
        if (playCount == getGlobal(NUM_CONCLUDING_CRESCENDOS)) {
          put(playerId, settings.PLAYER_HAS_STOPPED, true); 
        } 
      }
    }
  }

  // ***********************
  // Performance Instruction Helpers
  // ***********************
  // instruction business logic, boolean predicates based on state and threshold tests against tunable parameters
  
  fun /*private*/ int reachedLastPhrase(int playerId) {
    phraseIdx(playerId) == NUM_PHRASES - 1;
  }

  fun /*private*/ int reachedLastPhraseCrescendo(int playerId) {
    get(playerId, settings.PLAYER_LAST_PHRASE_BEFORE_CRESCENDO_PLAY_COUNT) == settings.NUM_PLAYS_BEFORE_CONCLUDING_CRESCENDO;
  }

  fun /*private*/ int advancePhraseIdx(int playerId) {
    return !reachedLastPhrase(playerId) && exceedsThreshold(settings.PHRASE_ADVANCE_PROB);
  }

  fun /*private*/ int repeatCurPhrase(Sequence seq, int curPhrasePlayCount) {
    float seqDuration;
    Chord chord;
    while (seq.next() != null) {
      seqDuration += seq.current().notes[0].duration;
    }
    return curPhrasePlayCount * seqDuration < settings.MIN_REPEAT_PHRASE_DURATION
  }

  fun /*private*/ int seekingUnison(int playerId) {
    playersPhraseIdxRange() < settings.MAX_PHRASES_IDX_RANGE_FOR_SEEKING_UNISON => int inRange;
    return inRange && exceedsThreshold(setttings.UNISON_PROB);
  }

  fun /*private*/ int seekingCrescendo(int playerId) {
    ampRange() => float curAmpRange;
    assertFloatLessThan(ampRange, settings.MAX_AMP_RANGE_FOR_SEEKING_CRESCENDO) => int ampInMaxRange;
    return ampInMaxRange && exceedsThreshold(settings.CRESCENDO_PROB);
  }
 
  fun /*private*/ int seekingDiminuendo(int playerId) {
    ampRange() => float curAmpRange;
    assertFloatLessThan(ampRange, settings.MAX_AMP_RANGE_FOR_SEEKING_DIMINUENDO) => int ampInMaxRange;
    return ampInMaxRange && exceedsThreshold(settings.DIMINUENDO_PROB);
  }
 
  fun /*private*/ int rest(int playerId) {
    1.0 => float stayAtRestProbFactor;
    if (get(playerId, PLAYER_AT_REST)) {
      STAY_AT_REST_PROB_FACTOR => stayAtRestProbFactor;
    }
    return exceedsThreshold(settings.REST_PROB_FACTOR * stayAtRestProbFactor);
  }

  fun /*private*/ int adjustPhase(int playerId) {
    settings.ADJ_PHASE_PROB => float adjPhaseProb;
    if (get(playerId, PLAYER_ADJ_PHASE_COUNT) <= settings.ADJ_PHASE_COUNT_THRESHOLD) {
      adjPhaseProb * settings.ADJ_PHASE_PROB_INCREASE_FACTOR => adjPhaseProb;
    }

    exceedsThreshold(adjPhaseProb) => int adjustPhase;
    if (adjustPhase) {
      increment(playerId, PLAYER_ADJ_PHASE_COUNT);
    }

    return adjustPhase;
  }

  fun /*private*/ int tooFarBehind(int playerId) {
    if (reachedLastPhrase(playerId) || get(playerId, PLAYER_HAS_ADVANCED)) {
      return false;
    }
    return getAllMaxInt(PHRASE_IDX) - get(playerId, PHRASE_IDX) >= settings.PHRASES_IDX_RANGE_THRESHOLD;
  }

  fun /*private*/ int transpose(int playerId) {
    return exceedsThreshold(settings.TRANSPOSE_PROB_FACTOR);
  }

  fun /*private*/ int ensembleReachedLastPhrase() {
    playerPhraseMap.keys() @=> string playerIds[];
    for (0 => int i; i <  playerIds.size(); i++) {
      if (!reachedLastPhrase(playerIds[i])) {
        return false;
      }
    }
    return true;
  }

  fun /*private*/ int ensembleReachedLastPhraseCrescendo() {
    playerPhraseMap.keys() @=> string playerIds[];
    for (0 => int i; i <  playerIds.size(); i++) {
      if (!reachedLastPhraseCrescendo(playerIds[i])) {
        return false;
      }
    }
    return true;
  }

  // ***********************
  // Performance Instruction Util Helpers
  // ***********************
  // non-boolean getters or calculations of derived values

  fun /*private*/ float ampRange() {
    return getAllMaxFlt(GAIN) - getAllMinFlt(GAIN);  
  }
 
  fun /*private*/ int phraseIdx(int playerId) {
    return get(playerId, PHRASE_IDX);
  }

  fun /*private*/ Sequence phrase(int playerId) {
    playerPhraseMap.get(idToKey(playerId)) $ Sequence => Sequence playerPhrase;
    return playerPhrase;
  }

  fun /*private*/ int hasAdvanced(int playerId) {
    return get(playerId, PLAYER_HAS_ADVANCED);
  }

  fun /*private*/ int playersPhraseIdxRange() {
    return getAllMaxInt(PHRASE_IDX) - getAllMinInt(PHRASE_IDX);
  }

  fun /*private*/ float gainAdjFactor(int playerId) {
    ensembleMaxGain() => float ensembleMaxGain;
    if (assertFloatEqual(maxGain, 0.0)) {
      1.0 => maxGain;
    }
    getPlayerMaxGain(Std.ito(playerId)) => float playerMaxGain;
    playerMaxGain / ensembleMaxGain => float gainRatio;
    if (seekingCrescendo(playerId) && gainRatio < GAIN_ADJ_CRESCENDO_RATIO_THRESHOLD) {
      return GAIN_CRESCENDO_ADJ_FACTOR;
    } else if (seekingDiminuendo(playerId) && gainRatio < GAIN_ADJ_DIMINUENDO_RATIO_THRESHOLD) {
      return GAIN_DIMINUENDO_ADJ_FACTOR;
    } else {
      return NO_FACTOR;
    }
  }

  fun float transposeFactor(int playerId) {
    phrase(playerId) @=> Sequence playerPhrase;
    dur total;
    while (playerPhrase.next() != null) {
      total += playerPhrase.current().notes[0].duration;
    }
    total / playerPhrase.size() => meanPhraseDuration;
    if (exceedsThreshold(settings.TRANSPOSE_DOWN_PROB_FACTOR) && meanPhraseDuration >= settings.TRANSPOSE_DOWN_DUR_THRESHOLD) {
      return settings.TRANSPOSE_SHIFT_DOWN_FACTOR;
    } else {
      return settings.TRANSPOSE_SHIFT_UP_FACTOR;
    }
  }

  fun /*private*/ float getPlayerMaxGain(string playerId) [
    playerPhraseMap.get(playerId) $ Sequence => Sequence playerPhrase;
    0.0 => float maxGain;
    for (0 => int i; i < playerPhrase.size(); i++) {
      Math.max(playerPhrase.chords[i][0].gain, maxGain) => maxGain;
    }
    return maxGain;
  }

  fun /*private*/ float ensembleMaxGain() {
    0.0 => float maxGain;
    playerPhraseMap.keys() => string playerIdKeys[];
    for (0 => int i; i < playerIdKeys.size(); i++) {
      Math.max(getPlayerMaxGain(playerIdKeys[i]), maxGain) => maxGain;
    }
    return maxGain;
  }

  fun /*private*/ string idToKey(int playerId) {
    return Std.itoa(playerId);
  }

  fun /*private*/ void increment(int playerId, string key) {
    put(playerId, key, get(playerId, key) + 1);
  }
}
