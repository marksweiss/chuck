// Machine.add("lib/arg_parser/arg_base.ck"); 
// Machine.add("lib/arg_parser/float_arg.ck"); 
// Machine.add("lib/arg_parser/int_arg.ck"); 
// Machine.add("lib/arg_parser/dur_arg.ck"); 
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
  // PLAYER CONF
  // *******************
  Note N;
  NoteConst NC;
  Clock K;
  Scale SCL;

  OrderedArgMap conf;
  OrderedObjectMap playerPhraseMap;
  float concludingCrescendoGainAdjustments[1];
  float concludingDecrescendoGainAdjustments[1];

  // *******************
  // State Keys for Player Conf
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
  "PLAYER_HAS_STOPPED" => string PLAYER_HAS_STOPPED;

  // *******************
  // State Keys for Ensemble Conf
  "NUM_PLAYERS" => string NUM_PLAYERS;
  "NUM_PHRASES" => string NUM_PHRASES;
  "ALL_PLAYERS_REACHED_UNISON" => string ALL_PLAYERS_REACHED_UNISON;
  "ALL_PLAYERS_REACHED_CONCLUSION" => string ALL_PLAYERS_REACHED_CONCLUSION;
  "ALL_PLAYERS_REACHED_LAST_PHRASE" => string ALL_PLAYERS_REACHED_LAST_PHRASE;
  "ALL_PLAYERS_REACHED_LAST_PHRASE_UNISON" => string ALL_PLAYERS_REACHED_LAST_PHRASE_UNISON; 
  "NUM_PLAYS_BEFORE_CONCLUDING_CRESCENDOS" => string NUM_PLAYS_BEFORE_CONCLUDING_CRESCENDO;
  "NUM_CONCLUDING_CRESCENDOS" => string NUM_CONCLUDING_CRESCENDOS;
  "ALL_PLAYERS_STOPPED" => string ALL_PLAYERS_STOPPED;
  
  // *******************
  // Conf constants
  1.0 => float NO_FACTOR;
 
  // Player must play each phrase at least this long
  // Insures that short phrases are played enough to counterpoint with longer phrases
  "MIN_REPEAT_PHRASE_DURATION" => string  MIN_REPEAT_PHRASE_DURATION;
  conf.put(DurationArg.make(MIN_REPEAT_PHRASE_DURATION, 2.0 * NC.REST_1.duration));

  // The most important factor governing advance of Players through phrases, this is simply
  // the percentage prob that they advance on any given iteration  
  "PHRASE_ADVANCE_PROB" => string PHRASE_ADVANCE_PROB;
  // assumes range [0, 100), i.e. this advances 28% of the time
  conf.put(IntArg.make(PHRASE_ADVANCE_PROB, 28));

  // Player Phrase Phase 
  // Tunable parms for shifting playing of current phrase out of its current
  // phase, and also to shift it more in alignment.  Shift simple pre-pends
  // a rest Note to current phrase before writing it to Score.  Supports
  // score directive to adjust phase, and another to move in and out of phase
  // during a performance
  
  // Percentage prob that a Player will adjust phase on any given iteration
  "ADJ_PHASE_PROB" => string ADJ_PHASE_PROB;
  conf.put(IntArg.make(ADJ_PHASE_PROB, 7));
  // Supports Instruction that Player this is too often in alignment should favor
  // trying to be out of phase a bit more. If Player hasn't adjusted phase
  // this many times or more, then adj_phase_prob_increase_factor will be applied
  "ADJ_PHASE_COUNT_THRESHOLD" => string ADJ_PHASE_COUNT_THRESHOLD;
  conf.put(IntArg.make(ADJ_PHASE_COUNT_THRESHOLD, 1));
  "ADJ_PHASE_PROB_INCREASE_FACTOR" => string ADJ_PHASE_PROB_INCREASE_FACTOR;
  conf.put(IntArg.make(ADJ_PHASE_PROB_INCREASE_FACTOR, 2));
  // The length of the rest Note (in seconds) inserted if a Player is adjusting its phase  
  K.QRTR => dur PHASE_ADJ_NOTE_DUR;
  N.make(0, NC.NO_GAIN, PHASE_ADJ_NOTE_DUR) @=> Note PHASE_ADJ_REST_NOTE;

  // Prob that a Player will seek unison on any given iteration.  The idea is that
  // to seek unison the Ensemble and all the Players must seek unison  
  "PLAYER_UNISON_PROB" => string PLAYER_UNISON_PROB;
  conf.put(IntArg.make(PLAYER_UNISON_PROB, 20));

  // Player Rest/Play
  // Tunable parms for probability that Player will rest rather than playing a note.
  // Supports score directive to listen as well as play and not always play
  // Prob that a Player will try to rest on a given iteration (not play)
  "REST_PROB_FACTOR" => string REST_PROB_FACTOR; 
  conf.put(IntArg.make(REST_PROB_FACTOR, 10));
  // Factor multiplied by rest_prob_factor if the Player is already at rest  
  "STAY_AT_REST_PROB_FACTOR" => string STAY_AT_REST_PROB_FACTOR;
  conf.put(FloatArg.make(STAY_AT_REST_PROB_FACTOR, 1.5));
  
  // Player Volume Adjusment, De/Crescendo
  // Tunable parms for adjusting volume up and down, and prob of making
  //  an amp adjustment. Supports score directive to have crescendos and
  //  decrescendos in the performance  

  // Threshold for the ratio of this Players average amp for its current phrase
  //  to the max average amp among all the Players. Ratio above/below this means the Player
  //  will raise/lower its amp by amp_de/crescendo_adj_factor    
  "GAIN_ADJ_CRESCENDO_RATIO_THRESHOLD" => string GAIN_ADJ_CRESCENDO_RATIO_THRESHOLD;
  conf.put(FloatArg.make(GAIN_ADJ_CRESCENDO_RATIO_THRESHOLD, 0.8));
  "GAIN_CRESCENDO_ADJ_FACTOR" => string GAIN_CRESCENDO_ADJ_FACTOR;
  conf.put(FloatArg.make(GAIN_CRESCENDO_ADJ_FACTOR, 1.1));
  "GAIN_ADJ_DECRESCENDO_RATIO_THRESHOLD" => string GAIN_ADJ_DECRESCENDO_RATIO_THRESHOLD;
  conf.put(FloatArg.make(GAIN_ADJ_DECRESCENDO_RATIO_THRESHOLD, 1.2));
  "GAIN_DECRESCENDO_ADJ_FACTOR" => string GAIN_DECRESCENDO_ADJ_FACTOR;
  conf.put(FloatArg.make(GAIN_DECRESCENDO_ADJ_FACTOR, 1.1));
  // Prob that a Player is seeking de/crescendo  
  "CRESCENDO_PROB" => string CRESCENDO_PROB;
  conf.put(IntArg.make(CRESCENDO_PROB, 50));
  "DECRESCENDO_PROB" => string DECRESCENDO_PROB;
  conf.put(IntArg.make(DECRESCENDO_PROB, 50));
  
  // Player Transpose
  // Tunable parms for transposing the playing of a phrase.  Suppports score directive
  //  to transpose as desired.
  // Prob that a Player will seek to transpose its current phrase
  "TRANSPOSE_PROB_FACTOR" => string TRANSPOSE_PROB_FACTOR;
  conf.put(IntArg.make(TRANSPOSE_PROB_FACTOR, 20));
  // Number of octaves to transpose if the Player does do so
  // Amount that represents the number of semitones to shift, e.g. 12 for one octave
  "TRANSPOSE_SHIFT_NUM_OCTAVES" => string TRANSPOSE_SHIFT_NUM_OCTAVES; 
  conf.put(IntArg.make(TRANSPOSE_SHIFT_NUM_OCTAVES, 1));
  // Sadly, we need this also, because CSound is float type and MIDI is int type (0.0 or 0)
  "TRANSPOSE_NO_SHIFT" => string TRANSPOSE_NO_SHIFT;
  conf.put(IntArg.make(TRANSPOSE_NO_SHIFT, 0));
  // Factor for shift down
  "TRANSPOSE_DOWN_FACTOR" => string TRANSPOSE_DOWN_FACTOR;
  conf.put(IntArg.make(TRANSPOSE_DOWN_FACTOR, -1));
  // Factor for shift up
  "TRANSPOSE_UP_FACTOR" => string TRANSPOSE_UP_FACTOR;  
  conf.put(IntArg.make(TRANSPOSE_UP_FACTOR, 1));
  // From the Instructions: "Transposing down by octaves works best on the patterns containing notes of long durations."
  // Minimum average duration of notes in a phrase for that phrase to be more likely
  //  to transpose down rather than up
  "TRANSPOSE_DOWN_PROB_FACTOR" => string TRANSPOSE_DOWN_PROB_FACTOR;
  conf.put(IntArg.make(TRANSPOSE_DOWN_PROB_FACTOR, 50));
  // Minimum average duration of notes in a phrase for that phrase to be more likely
  //  to transpose down rather than up  
  "TRANSPOSE_DOWN_DUR_THRESHOLD" => string TRANSPOSE_DOWN_DUR_THRESHOLD;
  conf.put(DurationArg.make(TRANSPOSE_DOWN_DUR_THRESHOLD, 2::second));

  // /PLAYER conf

  // *******************
  // ENSEMBLE conf
  // *******************

  // Threshold number of phrases behind the furthest ahead any Player is allowed to slip.
  // If they are more than 3 behind the leader, they must advance.     
  "PHRASES_IDX_RANGE_THRESHOLD" => string PHRASES_IDX_RANGE_THRESHOLD;
  conf.put(IntArg.make(PHRASES_IDX_RANGE_THRESHOLD, 3));
  // Prob that the Ensemble will seek to have all Players play the same phrase
  // on any one iteration
  "ENSEMBLE_UNISON_PROB" => string ENSEMBLE_UNISON_PROB;
  conf.put(IntArg.make(ENSEMBLE_UNISON_PROB, 90));
  // Threshold number of phrases apart within which all players 
  // must be for Ensemble to seek unison
  "MAX_PHRASES_IDX_RANGE_FOR_SEEKING_UNISON" => string MAX_PHRASES_IDX_RANGE_FOR_SEEKING_UNISON;
  conf.put(IntArg.make(MAX_PHRASES_IDX_RANGE_FOR_SEEKING_UNISON, 3));
  // Probability that the ensemble will de/crescendo in a unison (may be buggy)
  // TODO: bug is that code to build up crescendo over successive iterations isn't there
  // and instead this just jumps the amplitude jarringly on one iteration
  "ENSEMBLE_CRESCENDO_PROB" => string ENSEMBLE_CRESCENDO_PROB;
  conf.put(IntArg.make(ENSEMBLE_CRESCENDO_PROB, 20));
  "ENSEMBLE_DECRESCENDO_PROB" => string ENSEMBLE_DECRESCENDO_PROB;
  conf.put(IntArg.make(ENSEMBLE_DECRESCENDO_PROB, 5));
  // Maximum de/increase in volume (in CSound scale) that notes can gain in crescendo 
  // pursued during a unison or in the final Conclusion
  "MAX_GAIN_RANGE_FOR_SEEKING_CRESCENDO" => string MAX_GAIN_RANGE_FOR_SEEKING_CRESCENDO;
  conf.put(FloatArg.make(MAX_GAIN_RANGE_FOR_SEEKING_CRESCENDO, 0.2));
  // Maximum de/increase in volume (in CSound scale) that notes can gain in crescendo 
  "MAX_GAIN_RANGE_FOR_SEEKING_DECRESCENDO" => string MAX_GAIN_RANGE_FOR_SEEKING_DECRESCENDO;
  conf.put(FloatArg.make(MAX_GAIN_RANGE_FOR_SEEKING_DECRESCENDO, 0.2));
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
  conf.put(IntArg.make(MIN_NUM_CONCLUDING_CRESCENDOS, 2));
  "MAX_NUM_CONCLUDING_CRESCENDOS" => string MAX_NUM_CONCLUDING_CRESCENDOS;
  conf.put(IntArg.make(MAX_NUM_CONCLUDING_CRESCENDOS, 6));
  "MIN_LAST_PHRASE_REPETITIONS_BEFORE_CONCLUSION" => string MIN_LAST_PHRASE_REPETITIONS_BEFORE_CONCLUSION;
  conf.put(IntArg.make(MIN_LAST_PHRASE_REPETITIONS_BEFORE_CONCLUSION, 2));
  "MAX_LAST_PHRASE_REPETITIONS_BEFORE_CONCLUSION" => string MAX_LAST_PHRASE_REPETITIONS_BEFORE_CONCLUSION;
  conf.put(IntArg.make(MAX_LAST_PHRASE_REPETITIONS_BEFORE_CONCLUSION, 4));

  // /ENSEMBLE conf

  fun void init(int numPhrases, int numPlayers, Sequence lastPhrase) {
    putGlobal(NUM_PHRASES, numPhrases);
    putGlobal(NUM_PLAYERS, numPlayers);

    // initialize global state for all Players
    putGlobal(ALL_PLAYERS_REACHED_UNISON, false);
    putGlobal(ALL_PLAYERS_REACHED_LAST_PHRASE, false);
    putGlobal(ALL_PLAYERS_REACHED_LAST_PHRASE_UNISON, false);
    putGlobal(ALL_PLAYERS_STOPPED, false);
    // set now to use in conclusion, number of repetitions of last phrase before concluding crescendo
    // and number of concluding crescendos
    putGlobal(NUM_PLAYS_BEFORE_CONCLUDING_CRESCENDO,
              Std.rand2(conf.get(MIN_NUM_CONCLUDING_CRESCENDOS).intVal,
                        conf.get(MAX_NUM_CONCLUDING_CRESCENDOS).intVal));

    Std.rand2(conf.get(MIN_NUM_CONCLUDING_CRESCENDOS).intVal,
              conf.get(MAX_NUM_CONCLUDING_CRESCENDOS).intVal) => int numCrescendos;
    // times 2 because each iteration by a player in the crescendo is either the crescendo up or
    // decrescendo back down, instruction handler uses % to know whether the sign the player should apply to gain
    putGlobal(NUM_CONCLUDING_CRESCENDOS, 2 * numCrescendos);

    for (0 => int i; i < lastPhrase.size(); i++) {
      lastPhrase.chords[i].notes[0] @=> Note n;
      ((n.gain * conf.get(GAIN_CRESCENDO_ADJ_FACTOR).fltVal) - n.gain) /
        (numCrescendos $ float) => float chordCrescendoAdj;
      ((n.gain * conf.get(GAIN_DECRESCENDO_ADJ_FACTOR).fltVal) - n.gain) /
        (numCrescendos $ float) * -1.0 => float chordDecrescendoAdj;
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
    return getGlobal(ALL_PLAYERS_STOPPED).intVal == false;
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
  fun void update(int playerId, Sequence phrase) {
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
    if (!hasAdvanced(playerId) && seekingUnison(playerId) && ensembleSeekingUnison()) {
      increment(playerId, PHRASE_IDX);
      put(playerId, PLAYER_HAS_ADVANCED, true);
      put(playerId, PLAYER_HAS_REACHED_UNISON, true);
    }
  }

  // "It is very important that performers listen very carefully to one another and this means occasionally to drop out
  //  and listen. ... As an ensemble, it is very desirable to play very softly as well as very loudly and to try to diminuendo
  //  and crescendo together."
  fun void instructionRestOrCrescendoDecrescendo(int playerId) {
    NO_FACTOR => float gainAdj;
    if (rest(playerId)) {
      0.0 => gainAdj;
      put(playerId, PLAYER_AT_REST, true);
    } else {
      gainAdjFactor(playerId) => gainAdj;
      put(playerId, PLAYER_AT_REST, false);
    }

    Assert AS;
    if (AS.assertFloatNotEqual(gainAdj, NO_FACTOR)) {
      phrase(playerId) @=> Sequence playerPhrase;
      // for each chord in the phrase
      while (playerPhrase.next() != null) {
        playerPhrase.current() @=> Chord c;
        // for each note in the chord
        for (0 => int i; i < c.size(); i++) {
          // adjust the note's gain
          gainAdj *=> c.notes[i].gain;
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
      Chord phaseAdjRestChord;
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
      // sign of shift * number of octaves * num notes in octave
      transposeDirection(playerId) *
        conf.get(TRANSPOSE_SHIFT_NUM_OCTAVES).intVal *
        SCL.NUM_NOTES_IN_OCTAVE => int transposeInterval;

      phrase(playerId) @=> Sequence currentPhrase; 
      while (currentPhrase.next() != null) {
        currentPhrase.current() @=> Chord c;
        for (0 => int i; i < c.size(); i++) {
          transposeInterval +=> c.notes[i].pitch;
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
    if (!getBool(playerId, PLAYER_HAS_STOPPED) && reachedLastPhrase(playerId)) {
      put(playerId, PLAYER_REACHED_LAST_PHRASE, true);

      // now check if all players have reached the last phrase
      ensembleReachedLastPhraseCrescendo() => int inLastPhraseCrescendo; 
      
      if (ensembleReachedLastPhrase() && !inLastPhraseCrescendo) {
        // if the player is endtering the last phrase for the first time, set its count state
        if (!hasKey(playerId, PLAYER_LAST_PHRASE_BEFORE_CRESCENDO_PLAY_COUNT)) {
          put(playerId, PLAYER_LAST_PHRASE_BEFORE_CRESCENDO_PLAY_COUNT, 1);
        }
        // player is on the last phrase and not applying any gain change, so just play back the phrase no change
        get(playerId, PLAYER_LAST_PHRASE_BEFORE_CRESCENDO_PLAY_COUNT).intVal => int playCount;
        put(playerId, PLAYER_LAST_PHRASE_BEFORE_CRESCENDO_PLAY_COUNT, playCount + 1);
        
      } else if (inLastPhraseCrescendo) {
        if (!hasKey(playerId, PLAYER_LAST_PHRASE_CRESCENDO_PLAY_COUNT)) {
          put(playerId, PLAYER_LAST_PHRASE_BEFORE_CRESCENDO_PLAY_COUNT, 1);
        }
        get(playerId, PLAYER_LAST_PHRASE_CRESCENDO_PLAY_COUNT).intVal => int playCount;

        phrase(playerId) @=> Sequence currentPhrase; 
        // even iterations are crescendo, odd decrescendo
        // player is on a decrescendo this iteration, actually increment state that they
        // have completed a crescendo iteration
        if (playCount + 1 % 2 == 1) {
          for (0 => int i; i < concludingDecrescendoGainAdjustments.size(); i++) {
            concludingDecrescendoGainAdjustments[i] => float gainAdjFactor;  
            currentPhrase.chords[i] @=> Chord c;
            for (0 => int j; i < c.size(); j++) {
              gainAdjFactor +=> c.notes[j].gain;
            }
          }
        } else {
          for (0 => int i; i < concludingCrescendoGainAdjustments.size(); i++) {
            concludingCrescendoGainAdjustments[i] => float gainAdjFactor;  
            currentPhrase.chords[i] @=> Chord c;
            for (0 => int j; j < c.size(); j++) {
              gainAdjFactor +=> c.notes[j].gain;
            }
          }
        }
        playerPhraseMap.put(idToKey(playerId), currentPhrase);
        put(playerId, PLAYER_LAST_PHRASE_CRESCENDO_PLAY_COUNT, playCount++);
        
        // Set state for player being stopped if they have finished all crescendos
        if (playCount == getGlobal(NUM_CONCLUDING_CRESCENDOS).intVal) {
          put(playerId, PLAYER_HAS_STOPPED, true); 
        } 
      }
    }
  }

  // ***********************
  // Performance Instruction Helpers
  // ***********************
  // instruction business logic, boolean predicates based on state and threshold tests against tunable parameters
  
  fun /*private*/ int reachedLastPhrase(int playerId) {
    phraseIdx(playerId) == conf.get(NUM_PHRASES).intVal - 1;
  }

  fun /*private*/ int reachedLastPhraseCrescendo(int playerId) {
    return get(playerId, PLAYER_LAST_PHRASE_BEFORE_CRESCENDO_PLAY_COUNT).intVal ==
      conf.get(NUM_PLAYS_BEFORE_CONCLUDING_CRESCENDO).intVal;
  }

  fun /*private*/ int advancePhraseIdx(int playerId) {
    return !reachedLastPhrase(playerId) && exceedsThreshold(conf.get(PHRASE_ADVANCE_PROB).intVal);
  }

  fun /*private*/ int repeatCurPhrase(Sequence seq, int curPhrasePlayCount) {
    dur seqDuration;
    Chord chord;
    while (seq.next() != null) {
      seq.current().notes[0].duration +=> seqDuration; 
    }
    return curPhrasePlayCount * seqDuration < conf.get(MIN_REPEAT_PHRASE_DURATION).durVal;
  }

  fun /*private*/ int seekingUnison(int playerId) {
    playersPhraseIdxRange() < conf.get(MAX_PHRASES_IDX_RANGE_FOR_SEEKING_UNISON).intVal => int inRange;
    return inRange && exceedsThreshold(conf.get(PLAYER_UNISON_PROB).intVal);
  }

  fun /*private*/ int seekingCrescendo(int playerId) {
    ampRange() => float curAmpRange;
    Assert AS;
    AS.assertFloatLessThan(curAmpRange,
                           conf.get(MAX_GAIN_RANGE_FOR_SEEKING_CRESCENDO).fltVal) => int ampInMaxRange;
    return ampInMaxRange && exceedsThreshold(conf.get(CRESCENDO_PROB).intVal);
  }
 
  fun /*private*/ int seekingDiminuendo(int playerId) {
    ampRange() => float curAmpRange;
    Assert AS;
    AS.assertFloatLessThan(curAmpRange, conf.get(MAX_GAIN_RANGE_FOR_SEEKING_DECRESCENDO).fltVal) => int ampInMaxRange;
    return ampInMaxRange && exceedsThreshold(conf.get(DECRESCENDO_PROB).intVal);
  }
 
  fun /*private*/ int rest(int playerId) {
    1.0 => float stayAtRestProbFactor;
    if (get(playerId, PLAYER_AT_REST).intVal) {
      conf.get(STAY_AT_REST_PROB_FACTOR).intVal => stayAtRestProbFactor;
    }
    return exceedsThreshold(((conf.get(REST_PROB_FACTOR).intVal $ float) * stayAtRestProbFactor) $ int);
  }

  fun /*private*/ int adjustPhase(int playerId) {
    conf.get(ADJ_PHASE_PROB).intVal => int adjPhaseProb;
    if (get(playerId, PLAYER_ADJ_PHASE_COUNT).intVal <= conf.get(ADJ_PHASE_COUNT_THRESHOLD).intVal) {
      conf.get(ADJ_PHASE_PROB_INCREASE_FACTOR).intVal *=> adjPhaseProb;
    }

    exceedsThreshold(adjPhaseProb) => int adjustPhase;
    if (adjustPhase) {
      increment(playerId, PLAYER_ADJ_PHASE_COUNT);
    }

    return adjustPhase;
  }

  fun /*private*/ int tooFarBehind(int playerId) {
    if (reachedLastPhrase(playerId) || get(playerId, PLAYER_HAS_ADVANCED).intVal) {
      return false;
    }
    return getAllMaxInt(PHRASE_IDX) - get(playerId, PHRASE_IDX).intVal >= conf.get(PHRASES_IDX_RANGE_THRESHOLD).intVal;
  }

  fun /*private*/ int transpose(int playerId) {
    return exceedsThreshold(conf.get(TRANSPOSE_PROB_FACTOR).intVal);
  }

  fun /*private*/ int ensembleReachedLastPhrase() {
    playerPhraseMap.getKeys() @=> string playerIds[];
    for (0 => int i; i <  playerIds.size(); i++) {
      if (!reachedLastPhrase(Std.atoi(playerIds[i]))) {
        return false;
      }
    }
    return true;
  }

  fun /*private*/ int ensembleReachedLastPhraseCrescendo() {
    playerPhraseMap.getKeys() @=> string playerIds[];
    for (0 => int i; i <  playerIds.size(); i++) {
      if (!reachedLastPhraseCrescendo(Std.atoi(playerIds[i]))) {
        return false;
      }
    }
    return true;
  }

  fun /*private*/ int ensembleSeekingUnison() {
    return exceedsThreshold(conf.get(ENSEMBLE_UNISON_PROB).intVal);
  }

  fun /*private*/ int ensembleSeekingCrescendo() {
    return exceedsThreshold(conf.get(ENSEMBLE_CRESCENDO_PROB).intVal);
  }

  fun /*private*/ int ensembleSeekingDecrescendo() {
    return exceedsThreshold(conf.get(ENSEMBLE_DECRESCENDO_PROB).intVal);
  }

  // ***********************
  // Performance Instruction Util Helpers
  // ***********************
  // non-boolean getters or calculations of derived values

  // TODO FIX THIS
  // NEED TO RECORD MAX AND MIN GAIN FOR EACH PLAYER with PLAYER_MAX_GAIN and PLAYER_MIN_GAIN keys
  // each place they adjust gain and then retrieve it here
  fun /*private*/ float ampRange() {
    return getAllMaxFlt("GAIN") - getAllMinFlt("GAIN");
  }
 
  fun /*private*/ int phraseIdx(int playerId) {
    return get(playerId, PHRASE_IDX).intVal;
  }

  fun /*private*/ Sequence phrase(int playerId) {
    playerPhraseMap.get(idToKey(playerId)) $ Sequence @=> Sequence playerPhrase;
    return playerPhrase;
  }

  fun /*private*/ int hasAdvanced(int playerId) {
    return get(playerId, PLAYER_HAS_ADVANCED).intVal;
  }

  fun /*private*/ int playersPhraseIdxRange() {
    return getAllMaxInt(PHRASE_IDX) - getAllMinInt(PHRASE_IDX);
  }

  fun /*private*/ float gainAdjFactor(int playerId) {
    ensembleMaxGain() => float enMaxGain;
    Assert AS;
    if (AS.assertFloatEqual(enMaxGain, 0.0)) {
      1.0 => enMaxGain;
    }
    getPlayerMaxGain(idToKey(playerId)) => float playerMaxGain;
    playerMaxGain / enMaxGain => float gainRatio;
    if (seekingCrescendo(playerId) &&
        AS.assertFloatLessThan(gainRatio, conf.get(GAIN_ADJ_CRESCENDO_RATIO_THRESHOLD).fltVal)) {
      return conf.get(GAIN_CRESCENDO_ADJ_FACTOR).fltVal;
    } else if (seekingDiminuendo(playerId) && gainRatio < conf.get(GAIN_ADJ_DECRESCENDO_RATIO_THRESHOLD).fltVal) {
      return conf.get(GAIN_DECRESCENDO_ADJ_FACTOR).fltVal;
    } else {
      return NO_FACTOR;
    }
  }

  fun int transposeDirection(int playerId) {
    // early exit optimization to not do duration computation unless needed
    if (!exceedsThreshold(conf.get(TRANSPOSE_DOWN_PROB_FACTOR).intVal)) {
      return conf.get(TRANSPOSE_UP_FACTOR).intVal;
    }

    phrase(playerId) @=> Sequence playerPhrase;
    dur total;
    while (playerPhrase.next() != null) {
      playerPhrase.current().notes[0].duration +=> total; 
    }
    total / playerPhrase.size() => dur meanPhraseDuration;

    if (meanPhraseDuration >= conf.get(TRANSPOSE_DOWN_DUR_THRESHOLD).durVal) {
      return conf.get(TRANSPOSE_DOWN_FACTOR).intVal;
    }
    return conf.get(TRANSPOSE_UP_FACTOR).intVal;
  }

  fun /*private*/ float getPlayerMaxGain(string playerId) {
    playerPhraseMap.get(playerId) $ Sequence @=> Sequence playerPhrase;
    0.0 => float maxGain;
    for (0 => int i; i < playerPhrase.size(); i++) {
      Math.max(playerPhrase.chords[i].notes[0].gain, maxGain) => maxGain;
    }
    return maxGain;
  }

  fun /*private*/ float ensembleMaxGain() {
    0.0 => float maxGain;
    playerPhraseMap.getKeys() @=> string playerIdKeys[];
    for (0 => int i; i < playerIdKeys.size(); i++) {
      Math.max(getPlayerMaxGain(playerIdKeys[i]), maxGain) => maxGain;
    }
    return maxGain;
  }

  fun /*private*/ string idToKey(int playerId) {
    return Std.itoa(playerId);
  }

  fun /*private*/ void increment(int playerId, string key) {
    put(playerId, key, get(playerId, key).intVal + 1);
  }
}
