import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mobile/utils/gujarati_utils.dart';
import 'package:mobile/utils/gujarati_shaper.dart';

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
                left: 315, top: 347, // TODO: Adjust coordinates matches template
                child: pw.Text(GujaratiShaper.fix(fullName), style: pw.TextStyle(font: font, fontSize: 18, color: PdfColors.black)),
              ),
              
              // Standard
              pw.Positioned(
                left: 261, top: 382, 
                child: pw.Text(GujaratiShaper.fix(std.toString()), style: pw.TextStyle(font: font, fontSize: 18, color: PdfColors.black)),
              ),

              // Status (Commented out but fixed)
              // pw.Positioned(
              //   left: 300, top: 267,
              //   child: pw.Text(GujaratiShaper.fix(status), style: pw.TextStyle(font: font, fontSize: 18, color: PdfColors.black)),
              // ),

              // DOB (Figures)
              pw.Positioned(
                left: 53, top: 419,
                child: pw.Text(GujaratiShaper.fix(formattedDob), style: pw.TextStyle(font: font, fontSize: 18, color: PdfColors.black)),
              ),

              // DOB (Words)
              pw.Positioned(
                 left: 229, top: 419,
                 child: pw.Text(GujaratiShaper.fix(dobWords), style: pw.TextStyle(font: font, fontSize: 18, color: PdfColors.black)),
              ),

              // GR No
              pw.Positioned(
                left: 201, top: 458,
                child: pw.Text(GujaratiShaper.fix(grNo.toString()), style: pw.TextStyle(font: font, fontSize: 18, color: PdfColors.black)),
              ),
              
              // Today's Date (Bottom Left usually)
              pw.Positioned(
                left: 103, top: 693,
                child: pw.Text(GujaratiShaper.fix(todayDate), style: pw.TextStyle(font: font, fontSize: 16, color: PdfColors.black)),
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
    final grNo = student['grNo'] ?? '';
    final fatherOcc = student['fatherOcc'] ?? '';
    final motherOcc = student['motherOcc'] ?? '';
    final fatherEdu = student['fatherEdu'] ?? '';
    final motherEdu = student['motherEdu'] ?? '';
    final admissionDate = GujaratiUtils.formatDate(DateTime.parse((student['admissionDate'] ?? '').toString().split('T')[0]));
    
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
           const fontSize = 13.0;
           return pw.Stack(
            children: [
              pw.Image(image, fit: pw.BoxFit.cover),

              // Student Name
              pw.Positioned(
                left: 287.91, top: 135, 
                child: pw.Text(GujaratiShaper.fix(firstName), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
              // Father Name
              pw.Positioned(
                left: 399, top: 135,
                child: pw.Text(GujaratiShaper.fix(fatherName), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
              // Surname
              pw.Positioned(
                left: 519, top: 135,
                child: pw.Text(GujaratiShaper.fix(lastName), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
              
              // English Name (No fix needed usually, usually Latin)
              pw.Positioned(
                 left: 264, top: 156,
                 child: pw.Text(englishName, style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
              
              // Father Details (Name repeated)
              pw.Positioned(
                  left: 217, top: 179,
                  child: pw.Text(GujaratiShaper.fix(fatherName), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              pw.Positioned(
                  left: 217, top: 270,
                  child: pw.Text(GujaratiShaper.fix(fatherOcc), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
              
              pw.Positioned(
                  left: 217, top: 204,
                  child: pw.Text(GujaratiShaper.fix(fatherEdu), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
              
              // Mother Name
              pw.Positioned(
                  left: 217, top: 225,
                  child: pw.Text(GujaratiShaper.fix(motherName), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              pw.Positioned(
                  left: 217, top: 292,
                  child: pw.Text(GujaratiShaper.fix(motherOcc), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              pw.Positioned(
                  left: 217, top: 246,
                  child: pw.Text(GujaratiShaper.fix(motherEdu), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
              
              // Caste
              pw.Positioned(
                  left: 217, top: 316,
                  child: pw.Text(GujaratiShaper.fix(castorReligion), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
                
              // Gender
              pw.Positioned(
                  left: 217, top: 336,
                  child: pw.Text(GujaratiShaper.fix(gender), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              // DOB Figures
              pw.Positioned(
                  left: 263, top: 360,
                  child: pw.Text(GujaratiShaper.fix(dobFormatted), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              // DOB Words
              pw.Positioned(
                  left: 263, top: 382,
                  child: pw.Text(GujaratiShaper.fix(dobWords), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              // Birth Place
                pw.Positioned(
                  left: 217, top: 404,
                  child: pw.Text(GujaratiShaper.fix(birthPlace), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              // Address
                pw.Positioned(
                  left: 217, top: 428,
                  child: pw.Text(GujaratiShaper.fix(address), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              // Mobile
                pw.Positioned(
                  left: 217, top: 450,
                  child: pw.Text(GujaratiShaper.fix(mobile), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              // Date
                pw.Positioned(
                  left: 61, top: 545,
                  child: pw.Text(GujaratiShaper.fix(todayDate), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              // Admission Date
              pw.Positioned(
                  left: 245, top: 606,
                  child: pw.Text(GujaratiShaper.fix(admissionDate), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              // GR No
              pw.Positioned(
                  left: 130, top: 606,
                  child: pw.Text(GujaratiShaper.fix(grNo.toString()), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
              
                pw.Positioned(
                  left: 217, top: 493,
                  child: pw.Text(GujaratiShaper.fix("જન્મ પ્રમાણપત્ર"), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              pw.Positioned(
                  left: 217, top: 472,
                  child: pw.Text(GujaratiShaper.fix("ગુજરાતી"), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),

              // Teacher Name
               pw.Positioned(
                 right: 356, top: 559,
                 child: pw.Text(GujaratiShaper.fix(teacherName), style: pw.TextStyle(font: font, fontSize: fontSize)),
              ),
            ],
          );
        },
      ),
    );
    return doc.save();
  }
}

