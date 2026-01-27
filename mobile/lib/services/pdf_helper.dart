import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class PdfHelper {
  /// Handles PDF bytes: Share/Download on Web, Print Preview on Mobile.
  static Future<void> openPdf(Uint8List pdfBytes, String filename) async {
    try {
      if (kIsWeb) {
        // Web: Share/Download to avoid hanging if print preview fails
        await Printing.sharePdf(
          bytes: pdfBytes, 
          filename: '$filename.pdf'
        );
      } else {
        // Mobile (Android/iOS): Native Print Preview
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfBytes,
          name: filename,
        );
      }
    } catch (e) {
      debugPrint("Error handling PDF: $e");
      // Fallback or rethrow if needed
    }
  }
}
