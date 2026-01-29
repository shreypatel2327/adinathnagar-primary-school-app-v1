/// Helper class to fix Gujarati text rendering issues in PDF generation.
/// Implements basic Indic shaping logic (Reph and Pre-base Matra reordering).
class GujaratiShaper {
  // --- Constants ---
  static const int _ka = 0x0A95;
  static const int _ha = 0x0AB9;
  static const int _ra = 0x0AB0;
  static const int _virama = 0x0ACD;
  static const int _iMatra = 0x0ABF; // િ
  static const int _zwj = 0x200D;
  static const int _zwnj = 0x200C;
  static const int _nbsp = 0x00A0;

  static const Set<int> _independentVowels = {
    0x0A85, 0x0A86, 0x0A87, 0x0A88, 0x0A89, 0x0A8A, 0x0A8B, 0x0A8C, 0x0A8F, 0x0A90, 0x0A93, 0x0A94,
    0x0A8D, 0x0A91 // CANDRA E, O
  };

  static const Set<int> _consonants = {
    // Ka to Ha
    0x0A95, 0x0A96, 0x0A97, 0x0A98, 0x0A99, 0x0A9A, 0x0A9B, 0x0A9C, 0x0A9D, 0x0A9E, 0x0A9F,
    0x0AA0, 0x0AA1, 0x0AA2, 0x0AA3, 0x0AA4, 0x0AA5, 0x0AA6, 0x0AA7, 0x0AA8, 0x0AAA, 0x0AAB,
    0x0AAC, 0x0AAD, 0x0AAE, 0x0AAF, 0x0AB0, 0x0AB2, 0x0AB3, 0x0AB5, 0x0AB6, 0x0AB7, 0x0AB8, 0x0AB9,
    // Extensions
    // 0x0QA etc are usually sequences (Ka + Nukta). We handle sequences by parts. 
    // If specific characters exist, add them. For now, removing invalid placeholders.

  };

  static bool _isConsonant(int char) {
    return (char >= 0x0A95 && char <= 0x0AB9) || 
           (char >= 0x0AE6 && char <= 0x0AEF) || // Digits treated as base often
           (char == 0x0A59 || char == 0x0A5A || char == 0x0A5B || char == 0x0A5C || char == 0x0A5E);
  }

  static bool _isMatra(int char) {
    return (char >= 0x0ABE && char <= 0x0ACC) || (char == 0x0A81 || char == 0x0A82 || char == 0x0A83);
  }

  static bool _isHalant(int char) => char == _virama;

  /// Main fix function.
  static String fix(String? text) {
    if (text == null || text.isEmpty) return "";

    List<int> chars = text.runes.toList();
    List<int> output = [];

    // Simple state machine to parse syllables
    // Syllable = [Ra+H] + [Cons+H]* + Cons + [Matras]*
    
    int i = 0;
    while (i < chars.length) {
      int currentChar = chars[i];

      if (!_isConsonant(currentChar) && !_independentVowels.contains(currentChar) && currentChar != _iMatra) {
          // If it's a random symbol, spacing, or other mark not starting a syllable, just append.
          // Note: Independent vowels usually stand alone or start syllable?
          // For logic simplicity, treat as base.
          output.add(currentChar);
          i++;
          continue;
      }

      // Start of a potential syllable
      // Collect all characters belonging to this syllable
      List<int> syllable = [];
      
      // Look ahead to consume the full syllable
      int j = i;
      while (j < chars.length) {
        int c = chars[j];
        
        // Break if we hit a new start (Consonant or Indep Vowel) AND previous wasn't a Joiner/Halant?
        // Logic: 
        // 1. If we are just starting (j==i), accept.
        // 2. If we see a Halant, we expect next to be Consonant (or ZWJ/ZWNJ).
        // 3. If we see Matra, it attaches to previous.
        // 4. If we see new Consonant NOT preceded by Halant, it's a new syllable.
        
        if (j > i) {
           bool prevIsHalant = chars[j-1] == _virama;
           bool prevIsJoiner = chars[j-1] == _zwj || chars[j-1] == _zwnj; // Assuming joiners keep syllable
           
           if (_isConsonant(c) || _independentVowels.contains(c)) {
             if (!prevIsHalant) {
               // New syllable start
               break;
             }
           } else if (c == _nbsp || c == 0x0020) {
             break; // Space breaks syllable
           }
        }
        
        syllable.add(c);
        j++;
      }

      // Process the collected syllable
      if (syllable.isNotEmpty) {
        output.addAll(_processSyllable(syllable));
      }
      
      i = j;
    }

    return String.fromCharCodes(output);
  }

  /// Reorders logic for a single syllable
  static List<int> _processSyllable(List<int> syllable) {
     if (syllable.isEmpty) return [];

     // 1. Check for Reph (Ra + Virama) at start
     bool hasReph = false;
     if (syllable.length >= 2 && syllable[0] == _ra && syllable[1] == _virama) {
        // Check for ZWJ (Ra+Vir+ZWJ = Eyelash Ra, not Reph)
        if (syllable.length > 2 && syllable[2] == _zwj) {
           hasReph = false; 
        } else {
           hasReph = true;
        }
     }

     List<int> reph = [];
     List<int> core = [];
     
     if (hasReph) {
       reph = [syllable[0], syllable[1]]; // Ra, Virama
       core = syllable.sublist(2);
     } else {
       core = List.from(syllable);
     }

     if (core.isEmpty) {
        return syllable; // Just Ra+Vir?
     }

     // 2. Separate Matra I (0x0ABF)
     List<int> finalCore = [];
     List<int> matraI = [];
     
     for (int x in core) {
        if (x == _iMatra) {
          matraI.add(x);
        } else {
          finalCore.add(x);
        }
     }
     
     // 3. Re-assemble in Visual/Linear order for Dumb Rendering
     // Order: [Reph] + [Matra I] + [Core]
     //
     // Explanation:
     // - Reph (Ra+Vir): In dumb rendering, 'Ra'+'Vir' before Base reads as 'R' + 'Base'. 
     //   Moving it after Base ('Base'+'R') changes pronunciation to 'Base'+'R'.
     //   So we KEEP Reph at the start (Stage 2 Order).
     // - Matra I: Visual placement is to the left (before) the cluster.
     //   So we move it before the Core.
     // - Core: Base Consonant + other matras + Pre-base consonants (in conjuncts).
     //   We assume Core is [PreCons] [Vir] [Base] [PostMatras].
     //   Matra I goes before PreCons.
     //   Reph goes before Matra I (because Reph sits 'top/left' or is pronounced first).
     
     List<int> result = [];
     result.addAll(reph);
     result.addAll(matraI);
     result.addAll(finalCore);
     
     return result;
  }
}