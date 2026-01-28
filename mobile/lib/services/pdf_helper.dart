import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart'; // Still used for Web share
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PdfHelper {
  /// Handles PDF bytes: Share/Download on Web, Save & Open on Mobile.
  /// Returns the file path if saved locally (Mobile), or null if handled via Web share.
  static Future<String?> openPdf(Uint8List pdfBytes, String filename) async {
    try {
      if (kIsWeb) {
        // Web: Share/Download
        await Printing.sharePdf(
          bytes: pdfBytes, 
          filename: '$filename.pdf'
        );
        return null;
      } else {
        // Mobile (Android/iOS): Save to Documents & Open
        final output = await getApplicationDocumentsDirectory();
        final file = File("${output.path}/$filename.pdf");
        await file.writeAsBytes(pdfBytes);
        
        await OpenFile.open(file.path);
        return file.path;
      }
    } catch (e) {
      debugPrint("Error handling PDF: $e");
      rethrow;
    }
  }
}
