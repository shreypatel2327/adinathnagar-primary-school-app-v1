import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mobile/utils/gujarati_utils.dart'; // Ensure this matches your utils path

class PdfService {
  
  static Future<Uint8List> generateBonafidePdf(Map<String, dynamic> student) async {
    final font = await PdfGoogleFonts.muktaVaaniRegular();
    final imageBytes = await rootBundle.load('assets/images/bonafide_template.png');
    final image = pw.MemoryImage(imageBytes.buffer.asUint8List());

    // Data Mapping
    final firstName = student['firstName'] ?? '';
    final middleName = student['middleName'] ?? '';
    final lastName = student['lastName'] ?? '';
    final fullName = '$firstName $middleName $lastName'.trim();
    
    final std = student['standard'] ?? '';
    final status = 'ચાલુ'; // Default status "Running/Current" or fetch from student
    final dob = student['dob'] ?? ''; // Expecting YYYY-MM-DD
    final grNo = student['grNo'] ?? '';
    
    // Date Conversions
    String todayDate = GujaratiUtils.formatDate(DateTime.now());
    
    String formattedDob = '';
    String dobWords = '';
    try {
        if (dob.isNotEmpty) {
           DateTime d = DateTime.parse(dob);
           formattedDob = GujaratiUtils.formatDate(d);
           dobWords = GujaratiUtils.dateToGujaratiWords(d);
        }
    } catch (e) {
        // Fallback if parsing fails
        formattedDob = dob; 
    }

    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Image(image, fit: pw.BoxFit.cover),
              
              // Full Name
              pw.Positioned(
                left: 150, top: 250, // TODO: Adjust coordinates matches template
                child: pw.Text(fullName, style: pw.TextStyle(font: font, fontSize: 18, color: PdfColors.black)),
              ),
              
              // Standard
              pw.Positioned(
                left: 100, top: 280, 
                child: pw.Text(std.toString(), style: pw.TextStyle(font: font, fontSize: 18, color: PdfColors.black)),
              ),

              // Status
              pw.Positioned(
                left: 300, top: 280,
                child: pw.Text(status, style: pw.TextStyle(font: font, fontSize: 18, color: PdfColors.black)),
              ),

              // DOB (Figures)
              pw.Positioned(
                left: 150, top: 310,
                child: pw.Text(formattedDob, style: pw.TextStyle(font: font, fontSize: 18, color: PdfColors.black)),
              ),

              // DOB (Words)
              pw.Positioned(
                 left: 300, top: 310,
                 child: pw.Text(dobWords, style: pw.TextStyle(font: font, fontSize: 18, color: PdfColors.black)),
              ),

              // GR No
              pw.Positioned(
                left: 150, top: 340,
                child: pw.Text(grNo.toString(), style: pw.TextStyle(font: font, fontSize: 18, color: PdfColors.black)),
              ),
              
              // Today's Date (Bottom Left usually)
              pw.Positioned(
                left: 50, bottom: 100,
                child: pw.Text(todayDate, style: pw.TextStyle(font: font, fontSize: 16, color: PdfColors.black)),
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  static Future<Uint8List> generateValiFormPdf(Map<String, dynamic> student) async {
    final font = await PdfGoogleFonts.muktaVaaniRegular();
    final imageBytes = await rootBundle.load('assets/images/valiform_template.png');
    final image = pw.MemoryImage(imageBytes.buffer.asUint8List());

    // Mapping fields
    final firstName = student['firstName'] ?? '';
    final middleName = student['middleName'] ?? '';
    final lastName = student['lastName'] ?? '';
    final fullName = '$firstName $middleName $lastName'.trim();
    final englishName = '$lastName $firstName $middleName'.toUpperCase(); 
    
    // Extended fields (assuming keys based on common naming)
    final fatherName = middleName;
    final motherName = student['motherName'] ?? '';
    final castorReligion = student['caste'] ?? '';
    final gender = student['gender'] ?? '';
    final dob = student['dob'] ?? '';
    final birthPlace = student['birthPlace'] ?? '';
    final address = student['address'] ?? '';
    final mobile = student['mobile'] ?? '';
    final teacherName = student['teacherName'] ?? '';
    
    // Format Dates
    String dobFormatted = '';
    String dobWords = '';
     try {
        if (dob.isNotEmpty) {
           DateTime d = DateTime.parse(dob);
           dobFormatted = GujaratiUtils.formatDate(d);
           dobWords = GujaratiUtils.dateToGujaratiWords(d);
        }
    } catch (e) {
        dobFormatted = dob;
    }
    
    String todayDate = GujaratiUtils.formatDate(DateTime.now());


    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
           const fontSize = 14.0;
           return pw.Stack(
            children: [
              pw.Image(image, fit: pw.BoxFit.cover),

              // Student Name
              pw.Positioned(
                left: 200, top: 150, 
                child: pw.Text(firstName, style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
              // Father Name
              pw.Positioned(
                left: 350, top: 150,
                child: pw.Text(fatherName, style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
              // Surname
              pw.Positioned(
                left: 500, top: 150,
                child: pw.Text(lastName, style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
              
              // English Name
              pw.Positioned(
                 left: 200, top: 180,
                 child: pw.Text(englishName, style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
              
              // Father Details (Name repeated)
              pw.Positioned(
                 left: 200, top: 220,
                 child: pw.Text(fatherName, style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
              
              // Mother Name
              pw.Positioned(
                 left: 200, top: 280,
                 child: pw.Text(motherName, style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
              
              // Caste
              pw.Positioned(
                 left: 200, top: 340,
                 child: pw.Text(castorReligion, style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
               
              // Gender
              pw.Positioned(
                 left: 200, top: 370,
                 child: pw.Text(gender, style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              // DOB Figures
              pw.Positioned(
                 left: 250, top: 400,
                 child: pw.Text(dobFormatted, style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              // DOB Words
              pw.Positioned(
                 left: 250, top: 430,
                 child: pw.Text(dobWords, style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              // Birth Place
               pw.Positioned(
                 left: 200, top: 460,
                 child: pw.Text(birthPlace, style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              // Address
               pw.Positioned(
                 left: 200, top: 500,
                 child: pw.Text(address, style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              // Mobile
               pw.Positioned(
                 left: 200, top: 540,
                 child: pw.Text(mobile, style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              // Date
               pw.Positioned(
                 left: 50, bottom: 150,
                 child: pw.Text(todayDate, style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
              
              // Teacher Name
               pw.Positioned(
                 right: 100, bottom: 150,
                 child: pw.Text(teacherName, style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
            ],
          );
        },
      ),
    );
    return doc.save();
  }
}
