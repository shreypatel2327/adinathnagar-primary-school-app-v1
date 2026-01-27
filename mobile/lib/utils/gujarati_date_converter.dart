
class GujaratiDateConverter {
  static const List<String> _daysWords = [
    "",
    "પહેલી", "બીજી", "ત્રીજી", "ચોથી", "પાંચમી", "છઠ્ઠી", "સાતમી", "આઠમી", "નવમી", "દસમી",
    "અગિયારમી", "બારમી", "તેરમી", "ચૌદમી", "પંદરમી", "સોળમી", "સત્તરમી", "અઢારમી", "ઓગણીસમી", "વીસમી",
    "એકવીસમી", "બાવીસમી", "તેવીસમી", "ચોવીસમી", "પચ્ચીસમી", "છવીસમી", "સત્તાવીસમી", "અઠ્ઠાવીસમી", "ઓગણત્રીસમી", "ત્રીસમી", "એકત્રીસમી"
  ];

  static const List<String> _monthsWords = [
    "જાન્યુઆરી", "ફેબ્રુઆરી", "માર્ચ", "એપ્રિલ", "મે", "જૂન", "જુલાઈ", "ઓગસ્ટ", "સપ્ટેમ્બર", "ઓક્ટોબર", "નવેમ્બર", "ડિસેમ્બર"
  ];

  static const List<String> _numberWords = [
    "", "એક", "બે", "ત્રણ", "ચાર", "પાંચ", "છ", "સાત", "આઠ", "નવ", "દસ",
    "અગિયાર", "બાર", "તેર", "ચૌદ", "પંદર", "સોળ", "સત્તર", "અઢાર", "ઓગણીસ", "વીસ",
    "એકવીસ", "બાવીસ", "તેવીસ", "ચોવીસ", "પચ્ચીસ", "છવીસ", "સત્તાવીસ", "અઠ્ઠાવીસ", "ઓગણત્રીસ", "ત્રીસ"
  ];

  /// Converts a Date string (YYYY-MM-DD or ISO) to Gujarati words
  /// Example: "2015-06-01" -> "પહેલી જૂન બે હજાર પંદર"
  static String convertDateToWords(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "";
    
    try {
      final date = DateTime.parse(dateStr);
      final day = date.day;
      final month = date.month - 1; // Adjust for 0-index array
      final year = date.year;

      final dayWord = (day < _daysWords.length) ? _daysWords[day] : "";
      final monthWord = (month >= 0 && month < _monthsWords.length) ? _monthsWords[month] : "";
      
      // Year Logic: "બે હજાર " + last two digits word
      // Matches JS logic: var yearWord = "બે હજાર " + (year === 2000 ? "" : getGujaratiNumberWord(year % 100));
      final lastTwoDigits = year % 100;
      final lastTwoDigitsWord = (year == 2000) ? "" : _getGujaratiNumberWord(lastTwoDigits);
      final yearWord = "બે હજાર $lastTwoDigitsWord";

      return "$dayWord $monthWord ${yearWord.trim()}";
    } catch (e) {
      return dateStr; // Fallback to original string if parse fails
    }
  }

  /// Helper for 1-99 numbers (currently supports up to 30 based on provided array, handled via fallback)
  static String _getGujaratiNumberWord(int n) {
    if (n < _numberWords.length) {
      return _numberWords[n];
    }
    return n.toString();
  }
}
