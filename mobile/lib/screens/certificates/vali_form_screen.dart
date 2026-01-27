import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:mobile/utils/gujarati_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:mobile/services/api_service.dart';
import 'package:mobile/services/pdf_helper.dart';
import 'package:mobile/services/pdf_service.dart';

class ValiFormScreen extends StatefulWidget {
  final Map<String, dynamic> student;

  const ValiFormScreen({super.key, required this.student});

  @override
  State<ValiFormScreen> createState() => _ValiFormScreenState();
}

class _ValiFormScreenState extends State<ValiFormScreen> {

  String get _baseUrl {
 return ApiService.baseUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Vali Form Preview', style: GoogleFonts.publicSans(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.edit, color: Colors.black), onPressed: () {}), 
        ],
      ),
      body: Column(
        children: [
           Expanded(
             child: PdfPreview(
               build: (format) => _generatePdf(format),
               canChangeOrientation: false,
               canChangePageFormat: false,
               allowPrinting: false,
               allowSharing: false,
               useActions: false, 
               scrollViewDecoration: BoxDecoration(
                 color: Colors.grey[100],
               ),
               pdfPreviewPageDecoration: BoxDecoration(
                 color: Colors.white,
                 boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
               ),
               loadingWidget: const Center(child: CircularProgressIndicator()),
               onError: (context, error) => Center(child: Text('Error: $error')),
             ),
           ),
           Container(
             padding: const EdgeInsets.all(16),
             color: Colors.white,
             child: Row(
               children: [
                 Expanded(
                   child: OutlinedButton.icon(
                     onPressed: () => _printPdf(context),
                     icon: const Icon(Icons.print, color: Colors.black),
                     label: Text('Print', style: GoogleFonts.publicSans(color: Colors.black, fontWeight: FontWeight.w600)),
                     style: OutlinedButton.styleFrom(
                       padding: const EdgeInsets.symmetric(vertical: 16),
                       side: const BorderSide(color: Colors.grey),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                     ),
                   ),
                 ),
                 const SizedBox(width: 16),
                 Expanded(
                   child: ElevatedButton.icon(
                     onPressed: () => _downloadPdf(context),
                     icon: const Icon(Icons.download, color: Colors.white),
                     label: Text('Download PDF', style: GoogleFonts.publicSans(color: Colors.white, fontWeight: FontWeight.w600)),
                     style: ElevatedButton.styleFrom(
                       backgroundColor: const Color(0xFF2B8CEE),
                       padding: const EdgeInsets.symmetric(vertical: 16),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                       elevation: 0,
                     ),
                   ),
                 ),
               ],
             ),
           )
        ],
      ),
    );
  }

  Future<void> _printPdf(BuildContext context) async {
       final pdf = await _generatePdf(PdfPageFormat.a4);
       await PdfHelper.openPdf(pdf, '${widget.student['firstName']}_ValiForm');
  }

  Future<void> _downloadPdf(BuildContext context) async {
      try {
        final pdf = await _generatePdf(PdfPageFormat.a4);
        await PdfHelper.openPdf(pdf, '${widget.student['firstName']}_ValiForm');
      } catch (e) {
        if(context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Download failed: $e')));
        }
      }
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    return PdfService.generateValiFormPdf(widget.student);
  }
}
