import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mobile/utils/gujarati_date_converter.dart';

class PdfGenerationService {
  /// Generates a certificate by overlaying text on a PNG template.
  /// 
  /// [type] must be either 'bonafide' or 'valiform' (matching the asset filename prefix).
  /// [data] contains all the dynamic fields.
  Future<void> generateCertificate({
    required String type,
    required Map<String, dynamic> data,
  }) async {
    final pdf = pw.Document();

    // 1. Load Gujarati Fonts
    // Using PdfGoogleFonts methods which fetch fonts at runtime or cache them.
    // Fallback to MuktaVaani for legacy service to avoid compile errors
    final fontRegular = await PdfGoogleFonts.muktaVaaniRegular();
    final fontBold = await PdfGoogleFonts.muktaVaaniBold();

    // 2. Load Template Image
    // Ensure you have added assets/images/bonafide_template.png and valiform_template.png to pubspec.yaml
    final String assetPath = type == 'bonafide' 
        ? 'assets/images/bonafide_template.png' 
        : 'assets/images/valiform_template.png';
    
    final imageBytes = await rootBundle.load(assetPath);
    final image = pw.MemoryImage(imageBytes.buffer.asUint8List());

    // 3. Create PDF Page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero, // Full bleed for the background image
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // Background Image
              pw.Positioned.fill(
                child: pw.Image(image, fit: pw.BoxFit.fill),
              ),
              
              // Overlay Fields specific to type
              if (type == 'bonafide') 
                ..._buildBonafideFields(data, fontRegular, fontBold)
              else 
                ..._buildValiFormFields(data, fontRegular, fontBold),
            ],
          );
        },
      ),
    );

    // 4. Trigger Print/Preview
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: "${data['name'] ?? 'Certificate'}_$type.pdf",
    );
  }

  // ==========================================
  // BONAFIDE CERTIFICATE OVERLAYS
  // ==========================================
  List<pw.Widget> _buildBonafideFields(
    Map<String, dynamic> data, 
    pw.Font fontRegular, 
    pw.Font fontBold
  ) {
    // Helper to simplify positioning
    // NOTE: A4 width ~595, height ~842. Adjust coordinates (top, left) as needed.
    pw.Widget _text(String text, double top, double left, {bool isBold = false}) {
      return pw.Positioned(
        top: top,
        left: left,
        child: pw.Text(
          text,
          style: pw.TextStyle(
            font: isBold ? fontBold : fontRegular,
            fontSize: 18, // Match JS: font-size: 18px
            color: PdfColors.black,
          ),
        ),
      );
    }

    final dob = data['dob'] as String? ?? "";
    final dobWords = GujaratiDateConverter.convertDateToWords(dob);
    
    // Attempt to format date nicely (DD/MM/YYYY)
    String formattedDob = dob;
    try {
        if(dob.isNotEmpty) {
           final d = DateTime.parse(dob);
           formattedDob = "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
        }
    } catch (_) {}

    return [
      // Adjust TOP/LEFT here based on exact lines in your PNG
      // Example coordinates are placeholders. You MUST tweak these.
      
      // Name (શ્રી ...)
      _text(data['fullName'] ?? '', 320, 150, isBold: true), 
      
      // Std (ધો.)
      _text(data['std'] ?? '', 350, 200, isBold: true),
      
      // Status (માં ...)
      _text(data['status'] ?? '', 350, 400, isBold: false),

      // DOB (જન્મ તારીખ [Digits])
      _text(formattedDob, 380, 200, isBold: true),

      // DOB Words (શબ્દોમાં)
      _text(dobWords, 410, 150, isBold: true),

      // GR No (વયપત્રક નંબર)
      _text(data['grNo'] ?? '', 440, 250, isBold: true),

      // Today's Date (Bottom Left)
      _text(data['today'] ?? '', 600, 100, isBold: true),
    ];
  }

  // ==========================================
  // VALI FORM OVERLAYS
  // ==========================================
  List<pw.Widget> _buildValiFormFields(
    Map<String, dynamic> data, 
    pw.Font fontRegular, 
    pw.Font fontBold
  ) {
     // Vali Form is dense. Uses smaller font generally in JS (13px).
    pw.Widget _text(String text, double top, double left, {double fontSize = 13}) {
      return pw.Positioned(
        top: top,
        left: left,
        child: pw.Text(
          text,
          style: pw.TextStyle(
            font: fontRegular, // Mostly regular in table cells
            fontSize: fontSize,
            color: PdfColors.black,
          ),
        ),
      );
    }
    
    final dob = data['dob'] as String? ?? "";
    final dobWords = GujaratiDateConverter.convertDateToWords(dob);
    String formattedDob = dob;
     try {
        if(dob.isNotEmpty) {
           final d = DateTime.parse(dob);
           formattedDob = "${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}";
        }
    } catch (_) {}


    // Placeholder offsets based on a typical table structure. 
    // Since we are overlaying on an image defined by "valiform_template.png" (likely a screenshot of the HTML),
    // we need to guess the rows. Assuming ~30px per row height.
    return [
      // Form No (Top Right)
      _text(data['formNo']?.toString() ?? '', 80, 450, fontSize: 14),

      // -- Row 1: Name --
      // Name (Gujarati)
      _text(data['name'] ?? '', 160, 200),
      // Father Name
      _text(data['fname'] ?? '', 160, 350),
      // Surname
      _text(data['surname'] ?? '', 160, 480),

      // -- Row 2: Eng Name --
      // Eng Name
      _text((data['engName'] ?? '').toUpperCase(), 190, 200),

       // -- Row 3: Father Details --
      // Father Name
       _text(data['fname'] ?? '', 220, 200),
      // Father Edu
       _text(data['fEdu'] ?? '', 250, 200),

       // -- Row 4: Mother Details --
      // Mother Name
       _text(data['mName'] ?? '', 280, 200),
      // Mother Edu
       _text(data['mEdu'] ?? '', 310, 200),

       // -- Row 5: Occ --
       // Father Occ
       _text(data['fOcc'] ?? '', 340, 200),
       // Mother Occ
       _text(data['mOcc'] ?? '', 370, 100), // Check alignment

       // -- Row 6: Caste --
       _text(data['caste'] ?? '', 400, 200),
       
       // -- Row 7: Gender --
       _text(data['gender'] ?? '', 430, 200),

       // -- Row 8: DOB --
       // Digits
       _text(formattedDob, 460, 200),
       // Words
       _text(dobWords, 490, 200),

       // -- Row 9: Birth Place --
       _text(data['bPlace'] ?? '', 520, 200),

       // -- Row 10: Address & Mobile --
       // Address
       _text(data['address'] ?? '', 550, 200),
       // Mobile
       _text(data['mobile'] ?? '', 580, 200),

        // -- Row 11: Mother Tongue --
       _text(data['mTongue'] ?? '', 610, 200),

       // -- Row 12: Doc --
       _text(data['doc'] ?? '', 640, 200),

       // Footer
       // Date
       _text(data['date'] ?? '', 700, 80),
       // Teacher Name
       _text(data['teacherName'] ?? '', 700, 400, fontSize: 13),
    ];
  }
}
