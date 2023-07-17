public class InCHelper {
  fun static void getScore(int bpm, Sequences seqs[]) {
    // declare chords / notes for each sequence
    NoteConst N;
    N.init(bpm);
    Note T;
    ScaleConst S;
    S.init(bpm);

    // The 53 phrases of "In C"
    // 1-6
    addPhrase([N.C4_8, N.E4_4, N.C4_8, N.E4_4, N.C4_8, N.E4_4], seqs);
    addPhrase([N.C4_8, N.E4_8, N.F4_8, N.E4_4], seqs);
    addPhrase([N.REST_8, N.E4_8, N.F4_8, N.E4_8], seqs);
    addPhrase([N.REST_8, N.E4_8, N.F4_8, N.G4_8], seqs);
    addPhrase([N.E4_8, N.F4_8, N.G4_8, N.REST_8], seqs);
    addPhrase([N.C5_1, N.C5_1], seqs);

    // 7-10
    addPhrase([N.REST_4, N.REST_4, N.REST_4, N.REST_8,
               N.C4_8, N.C4_8, N.C4_8,
               N.REST_8, N.REST_4, N.REST_4, N.REST_4], seqs);
    addPhrase([T.dotN(N.G4_1), N.F4_1, N.F4_1], seqs);
    addPhrase([N.B4_16, N.G4_16, N.REST_8, N.REST_4, N.REST_4, N.REST_4], seqs);
    addPhrase([N.B4_16, N.G4_16], seqs);

    // 11-15
    addPhrase([N.F4_16, N.B4_16, N.G4_16, N.F4_16, N.G4_16, N.B4_16], seqs);
    addPhrase([N.F4_8, N.G4_8, N.B4_1, N.C5_4], seqs);
    addPhrase([N.B4_16, T.dotN(N.G4_8), N.G4_16, N.F4_16, T.dotN(N.REST_8), N.G4_16, T.dotN(N.G4_2)], seqs);
    addPhrase([N.C5_1, N.B4_1, N.G4_1, N.Fs4_1], seqs);
    addPhrase([N.G4_16, T.dotN(N.REST_8), N.REST_4, N.REST_4, N.REST_4], seqs);

    // 16-21
    addPhrase([N.G4_16, N.B4_16, N.C5_16, N.B4_16], seqs);
    addPhrase([N.B4_16, N.C5_16, N.B4_16, N.C5_16, N.B4_16, N.REST_16], seqs);
    addPhrase([N.E4_16, N.Fs4_16, N.E4_16, N.Fs4_16, T.dotN(N.E4_8), N.E4_16], seqs);
    addPhrase([T.dotN(N.REST_4), T.dotN(N.G5_4)], seqs);
    addPhrase([N.E4_16, N.Fs4_16, N.E4_16, N.Fs4_16, T.dotN(N.G3_8), N.E4_16, N.E4_16, N.Fs4_16, N.E4_16, N.Fs4_16], seqs);
    addPhrase([T.dotN(N.Fs4_2)], seqs);

    // 22-24
    addPhrase([T.dotN(N.E4_4), T.dotN(N.E4_4), T.dotN(N.E4_4), T.dotN(N.E4_4), T.dotN(N.E4_4), T.dotN(N.Fs4_4), T.dotN(N.G4_4), T.dotN(N.A4_4), N.B4_8], seqs);
    addPhrase([N.E4_8, T.dotN(N.Fs4_4), T.dotN(N.Fs4_4), T.dotN(N.Fs4_4), T.dotN(N.Fs4_4), T.dotN(N.Fs4_4), T.dotN(N.G4_4), T.dotN(N.A4_4), N.B4_8], seqs);
    addPhrase([N.E4_8, N.Fs4_8, T.dotN(N.G4_4), T.dotN(N.G4_4), T.dotN(N.G4_4), T.dotN(N.G4_4), T.dotN(N.G4_4), T.dotN(N.A4_4), N.B4_8], seqs);

    // 25-28
    addPhrase([N.E4_8, N.Fs4_8, N.G4_8, T.dotN(N.A4_4), T.dotN(N.A4_4), T.dotN(N.A4_4), T.dotN(N.A4_4), T.dotN(N.A4_4), T.dotN(N.B4_4)], seqs);
    addPhrase([N.E4_8, N.Fs4_8, N.G4_8, N.A4_8, T.dotN(N.B4_4), T.dotN(N.B4_4), T.dotN(N.B4_4), T.dotN(N.B4_4), T.dotN(N.B4_4)], seqs);
    addPhrase([N.E4_16, N.Fs4_16, N.E4_16, N.Fs4_16, N.G8_4, N.E4_16, N.G4_16, N.Fs4_16, N.E4_16, N.Fs4_16, N.E4_16], seqs);
    addPhrase([N.E4_16, N.Fs4_16, N.E4_16, N.Fs4_16, T.dotN(N.E4_8), N.E4_16], seqs);

    // 29-34
    addPhrase([T.dotN(N.E4_2), T.dotN(N.G4_2), T.dotN(N.C5_2)], seqs);
    addPhrase([T.dotN(N.C5_1)], seqs);
    addPhrase([N.G4_16, N.F4_16, N.G4_16, N.B4_16, N.G4_16, N.B4_16], seqs);
    addPhrase([N.F4_16, N.G4_16, N.F4_16, N.G4_16, N.B4_16, N.F4_16, T.dotN(N.F4_2), T.dotN(N.G4_4)], seqs);
    addPhrase([N.G4_16, N.F4_16, N.REST_8], seqs);
    addPhrase([N.G4_16, N.F4_16], seqs);

    // 35
    addPhrase([N.G4_16, N.F4_16, N.G4_16, N.B4_16, N.G4_16, N.B4_16, N.G4_16, N.B4_16, N.G4_16, N.B4_16, N.REST_8, N.REST_4, N.REST_4, N.REST_4,
               N.Bf4_4, T.dotN(N.G5_2), N.A5_8, N.G5_8, N.G5_8, N.B5_8, N.A5_4, N.G5_8, T.dotN(N.E5_2), N.G5_8, N.Fs5_8, T.dotN(N.Fs5_2),
               N.REST_4, N.REST_4, N.REST_8, N.E5_8, N.E5_2, T.dotN(N.F5_1)], seqs);

    // 36-42
    addPhrase([N.D4_16, N.E4_16, N.G4_16, N.E4_16, N.G4_16, N.E4_16], seqs);
    addPhrase([N.D4_16, N.E4_16], seqs);
    addPhrase([N.D4_16, N.E4_16, N.G4_16], seqs);
    addPhrase([N.B4_16, N.G4_16, N.F4_16, N.G4_16, N.B4_16, N.C5_16], seqs);
    addPhrase([N.B4_16, N.F4_16], seqs);
    addPhrase([N.G4_16, N.E4_16], seqs);
    addPhrase([N.A4_1, N.G4_1, N.F4_1, N.A4_1], seqs);

    // 43-47
    addPhrase([N.F5_16, N.E5_16, N.F5_16, N.E5_16, N.E5_8, N.E5_8, N.E5_8, N.F5_16, N.E5_16], seqs);
    addPhrase([N.F5_8, N.E5_8, N.E5_8, N.E5_8, N.C5_4], seqs);
    addPhrase([N.D5_4, N.D5_4, N.G4_4], seqs);
    addPhrase([N.G4_16, N.D5_16, N.E5_16, N.D5_16, N.REST_8, N.G4_8, N.REST_8, N.G4_8, N.REST_8, N.G4_8, N.G4_16, N.D5_16, N.E5_16, N.D5_16], seqs);
    addPhrase([N.D5_16, N.E5_16, N.D5_8], seqs);

    // 48-53
    addPhrase([T.dotN(N.G4_1), N.G4_1, N.F4_1, N.F4_4], seqs);
    addPhrase([N.F4_16, N.G4_16, N.Bf4_16, N.G4_16, N.Bf4_16, N.G4_16], seqs);
    addPhrase([N.F4_16, N.G4_16], seqs);
    addPhrase([N.F4_16, N.G4_16, N.Bf4_16], seqs);
    addPhrase([N.G4_16, N.Bf4_16], seqs);
    addPhrase([N.Bf4_16, N.G4_16], seqs);
  }
  
  fun static Sequence makePhrase(Note phraseNotes[], int id) {
    Sequence seq;
    seq.init(Std.itoa(id), true);  // looping phrases 
    seq.add(phraseNotes);
    return seq;
  }

  fun /*private*/ static void addPhrase(Note phraseNotes[], Sequences seqs[]) {
    for (0 => int i; i < seqs.size(); ++i) {
      seqs[i].add(makePhrase(phraseNotes, i));
    } 
  }
}
