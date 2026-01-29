import 'dart:io';
import '../lib/utils/gujarati_shaper.dart';

void main() {
  File file = File('test_output.txt');
  StringBuffer sb = StringBuffer();

  // Test cases
  // 1. Dharma: Dha (0A97) + Ra (0AB0) + Vir (0ACD) + Ma (0AAE) -> Dha + Ma + Ra + Vir ?
  // Cpp Ref: Dha + Ra + Vir + Ma. Ra+Vir is Reph. Reph moves after base.
  // Base is Ma.
  // Expected: Dha + Ma + Ra + Vir.
  
  String dharma = "\u0AA7\u0AB0\u0ACD\u0AAE";
  sb.writeln("Dharma Input: \u0AA7 \u0AB0 \u0ACD \u0AAE");
  String fixedDharma = GujaratiShaper.fix(dharma);
  sb.writeln("Dharma Output: " + fixedDharma.runes.map((e) => e.toRadixString(16).toUpperCase()).join(" "));
  
  // 2. Harshil
  String harshil = "\u0AB9\u0AB0\u0ACD\u0AB7\u0ABF\u0AB2";
  sb.writeln("Harshil Input: \u0AB9 \u0AB0 \u0ACD \u0AB7 \u0ABF \u0AB2");
  String fixedHarshil = GujaratiShaper.fix(harshil);
  sb.writeln("Harshil Output: " + fixedHarshil.runes.map((e) => e.toRadixString(16).toUpperCase()).join(" "));
  
  // 3. Simple Matra I: Ki = Ka + i
  String ki = "\u0A95\u0ABF";
  sb.writeln("Ki Input: \u0A95 \u0ABF");
  String fixedKi = GujaratiShaper.fix(ki);
  sb.writeln("Ki Output: " + fixedKi.runes.map((e) => e.toRadixString(16).toUpperCase()).join(" "));

  file.writeAsStringSync(sb.toString());
}
