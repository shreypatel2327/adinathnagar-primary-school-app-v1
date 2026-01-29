import 'dart:io';
import '../lib/utils/gujarati_shaper.dart';

void main() {
  File file = File('test_output_new.txt');
  StringBuffer sb = StringBuffer();

  // Test cases
  
  // 1. Dharma (\u0AA7\u0AB0\u0ACD\u0AAE) [Dha Ra Vir Ma]
  // Expected Output: Dha + Ra + Vir + Ma (No change in order for Dumb rendering of Reph)
  String dharma = "\u0AA7\u0AB0\u0ACD\u0AAE";
  sb.writeln("Dharma Input: \u0AA7 \u0AB0 \u0ACD \u0AAE");
  String fixedDharma = GujaratiShaper.fix(dharma);
  sb.writeln("Dharma Output: " + fixedDharma.runes.map((e) => e.toRadixString(16).toUpperCase()).join(" "));
  
  // 2. Harshil (\u0AB9\u0AB0\u0ACD\u0AB7\u0ABF\u0AB2) [Ha Ra Vir Sha i La]
  // Expected Output: Ha + Ra + Vir + i + Sha + La
  String harshil = "\u0AB9\u0AB0\u0ACD\u0AB7\u0ABF\u0AB2";
  sb.writeln("Harshil Input: \u0AB9 \u0AB0 \u0ACD \u0AB7 \u0ABF \u0AB2");
  String fixedHarshil = GujaratiShaper.fix(harshil);
  sb.writeln("Harshil Output: " + fixedHarshil.runes.map((e) => e.toRadixString(16).toUpperCase()).join(" "));
  
  // 3. Ki (\u0A95\u0ABF) [Ka i]
  // Expected Output: i + Ka
  String ki = "\u0A95\u0ABF";
  sb.writeln("Ki Input: \u0A95 \u0ABF");
  String fixedKi = GujaratiShaper.fix(ki);
  sb.writeln("Ki Output: " + fixedKi.runes.map((e) => e.toRadixString(16).toUpperCase()).join(" "));

  file.writeAsStringSync(sb.toString());
}
