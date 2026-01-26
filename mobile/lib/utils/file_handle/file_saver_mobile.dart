
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

Future<void> saveExcelFile(List<int> bytes, String fileName) async {
  try {
    Directory? directory;
    if (Platform.isAndroid) {
          directory = await getExternalStorageDirectory(); 
    } else {
          directory = await getApplicationDocumentsDirectory();
    }
    
    String outputFile = "${directory!.path}/$fileName";
    File(outputFile)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);
      
    // Try to open it
    await OpenFile.open(outputFile);
  } catch (e) {
    throw Exception('Error saving file: $e');
  }
}
