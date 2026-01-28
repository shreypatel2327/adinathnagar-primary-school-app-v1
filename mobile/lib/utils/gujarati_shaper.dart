
/// Helper class to fix Gujarati text rendering issues in PDF generation.
/// Specifically handles reordering of the 'i' matra (HRASVA-I) which often
/// renders incorrectly in simple text engines.
class GujaratiShaper {
  static const int _ka = 0x0A95;
  static const int _ha = 0x0AB9;
  static const int _virama = 0x0ACD;
  static const int _ra = 0x0AB0;
  static const int _iMatra = 0x0ABF; // િ

  /// Fixes string for display by reordering characters for correct shaping.
  /// 
  /// Main fix: Reorders 'િ' (U+0ABF) to appear BEFORE the consonant cluster.
  static String fix(String? text) {
    if (text == null || text.isEmpty) return "";
    
    // Convert to runes for easier manipulation
    List<int> chars = text.runes.toList();
    List<int> result = [];

    for (int i = 0; i < chars.length; i++) {
        int currentChar = chars[i];
        
        if (currentChar == _iMatra) {
            // Processing 'i' Matra
            // We need to find the start of the syllable to insert this matra before it.
            
            // Temporary buffer to hold the syllable we are jumping over
            List<int> syllable = [];
            
            // Look backwards from current position
            int cursor = result.length - 1;
            bool stop = false;
            
            while (cursor >= 0 && !stop) {
                int c = result[cursor];
                
                // If character is a consonant
                if (_isConsonant(c)) {
                   syllable.insert(0, c);
                   
                   // Check for preceding Virama to see if this is part of a conjunct
                   if (cursor > 0 && result[cursor - 1] == _virama) {
                       // Normal conjunct (e.g. "સ્મિ" -> Sa + Vir + Ma)
                       // We consume the Virama and continue loop to next consonant
                       syllable.insert(0, result[cursor - 1]); // Add Virama
                       result.removeAt(cursor); // Remove Consonant
                       result.removeAt(cursor - 1); // Remove Virama
                       cursor -= 2;
                   } else {
                       // Single consonant or end of conjunct chain
                       stop = true;
                       result.removeAt(cursor); // Remove Consonant
                   }
                } else {
                    // Not a consonant (maybe another marks?). 
                    // If proper syntax, shouldn't happen immediately for simple cases.
                    // But if we hit a space or other matra, stop.
                    stop = true;
                }
            }
            
            // Now insert the 'i' matra, then the syllable
            result.add(_iMatra);
            result.addAll(syllable);
            
        } else {
            result.add(currentChar);
        }
    }
    
    return String.fromCharCodes(result);
  }

  static bool _isConsonant(int charCode) {
    return charCode >= _ka && charCode <= _ha;
  }
}
