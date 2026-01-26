
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/services/api_service.dart';
import 'package:mobile/utils/gujarati_utils.dart';
import 'package:mobile/utils/file_handle/file_saver.dart'; // Helper

class AavakRegisterScreen extends StatefulWidget {
  const AavakRegisterScreen({super.key});

  @override
  State<AavakRegisterScreen> createState() => _AavakRegisterScreenState();
}

class _AavakRegisterScreenState extends State<AavakRegisterScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _students = [];
  List<dynamic> _filteredStudents = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  
  // Filters
  String? _selectedStandard;
  String? _selectedYear;

  @override
  void initState() {
    super.initState();
    _fetchAavakStudents();
    _searchController.addListener(_applyFilters);
  }
  
  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudents = _students.where((s) {
        final name = (s['fullName'] ?? '').toString().toLowerCase();
        final gr = (s['grNo'] ?? '').toString();
        final standard = (s['standard'] ?? '').toString();
        // Extract year from admissionDate
        final admissionDate = s['admissionDate'] != null ? DateTime.tryParse(s['admissionDate']) : null;
        final year = admissionDate != null ? admissionDate.year.toString() : '';

        final matchesSearch = name.contains(query) || gr.contains(query);
        final matchesStandard = _selectedStandard == null || standard == _selectedStandard;
        final matchesYear = _selectedYear == null || year == _selectedYear;

        return matchesSearch && matchesStandard && matchesYear;
      }).toList();
    });
  }

  Future<void> _fetchAavakStudents() async {
    try {
      final data = await _apiService.getAavakStudents();
      if (mounted) {
        setState(() {
          _students = data;
          _filteredStudents = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
           _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _exportToExcel() async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    
    // Headers (ALL Fields)
    List<String> headers = [
      'GR No', 'Standard', 'Full Name', 'Gender', 'DOB', 'Birth Place', 
      'Caste', 'Category', 'Address', 'Mobile',
      'Old School GR', 'New School GR', 'Diet No', 'Previous School',
      'Father Name', 'Father Edu', 'Father Occ', 'Father Aadhaar', 'Father Name (Aadhaar)',
      'Mother Name', 'Mother Edu', 'Mother Occ', 'Mother Aadhaar',
      'Student Aadhaar', 'Name on Aadhaar', 'UID (DISE)', 'Ration Card', 
      'Birth Cert Name', 'Birth Cert No',
      'Bank Account', 'IFSC Code', 'Bank Name', 'Holder Name',
      'Admission Date', 'Academic Year', 'Result', 'Percentage', 'Attendance',
      'transportation', 'Handicapped', 'Handicap %'
    ];
    sheetObject.appendRow(headers.map((h) => TextCellValue(h)).toList());
    
    // Data
    for (var s in _filteredStudents) {
         String formatDate(String? d) {
             if (d == null) return '';
             final dt = DateTime.tryParse(d);
             if (dt == null) return '';
             return "${dt.day}/${dt.month}/${dt.year}";
         }

        List<CellValue> row = [
            IntCellValue(s['grNo'] ?? 0),
            IntCellValue(s['standard'] ?? 0),
            TextCellValue(s['fullName'] ?? ''),
            TextCellValue(s['gender'] ?? ''),
            TextCellValue(formatDate(s['dob'])),
            TextCellValue(s['birthPlace'] ?? ''),
            TextCellValue(s['caste'] ?? ''),
            TextCellValue(s['category'] ?? ''),
            TextCellValue(s['address'] ?? ''),
            TextCellValue(s['mobile'] ?? ''),
            
            TextCellValue(s['oldSchoolGrNo'] ?? ''),
            TextCellValue(s['newSchoolGrNo'] ?? ''),
            TextCellValue(s['dietNo'] ?? ''),
            TextCellValue(s['prevSchool'] ?? ''),
            
            TextCellValue(s['fatherName'] ?? ''),
            TextCellValue(s['fatherEdu'] ?? ''),
            TextCellValue(s['fatherOcc'] ?? ''),
            TextCellValue(s['fatherAadhaar'] ?? ''),
            TextCellValue(s['fatherNameOnAadhaar'] ?? ''),
            
            TextCellValue(s['motherName'] ?? ''),
            TextCellValue(s['motherEdu'] ?? ''),
            TextCellValue(s['motherOcc'] ?? ''),
            TextCellValue(s['motherAadhaar'] ?? ''),
            
            TextCellValue(s['aadhaarNo'] ?? ''),
            TextCellValue(s['nameOnAadhaar'] ?? ''),
            TextCellValue(s['uid'] ?? ''),
            TextCellValue(s['rationCard'] ?? ''),
            TextCellValue(s['birthCertName'] ?? ''),
            TextCellValue(s['birthCertNo'] ?? ''),
            
            TextCellValue(s['bankAccount'] ?? ''),
            TextCellValue(s['ifscCode'] ?? ''),
            TextCellValue(s['bankName'] ?? ''),
            TextCellValue(s['bankHolderName'] ?? ''),
            
            TextCellValue(formatDate(s['admissionDate'])),
            TextCellValue(s['academicYear'] ?? ''),
            TextCellValue(s['result'] ?? ''),
            DoubleCellValue((s['percentage'] ?? 0).toDouble()),
            DoubleCellValue((s['attendance'] ?? 0).toDouble()),
            
            TextCellValue(s['transportation'] ?? ''),
            TextCellValue(s['isHandicapped'] ?? ''),
            DoubleCellValue((s['handicapPercentage'] ?? 0).toDouble()),
        ];
        sheetObject.appendRow(row);
    }

    // Save using helper
    try {
        String fileName = "aavak_register_${DateTime.now().millisecondsSinceEpoch}.xlsx";
        final bytes = excel.save();
        if (bytes != null) {
             await saveExcelFile(bytes, fileName);
             if (mounted) {
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Excel downloaded: $fileName'),
                 ));
             }
        }
    } catch (e) {
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving Excel: $e')));
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('આવક રજીસ્ટર', style: GoogleFonts.notoSansGujarati(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.download, color: Color(0xFF1E8E3E)), 
              onPressed: _exportToExcel,
              tooltip: 'Export to Excel',
          )
        ],
      ),
      body: Column(
        children: [
           // Search & Header
           Container(
             color: Colors.white,
             padding: const EdgeInsets.all(16),
             child: Column(
               children: [
                 // Search Bar
                 TextField(
                   controller: _searchController,
                   decoration: InputDecoration(
                     hintText: 'નામ અથવા GR નં. થી શોધો',
                     hintStyle: GoogleFonts.notoSansGujarati(color: Colors.grey),
                     prefixIcon: const Icon(Icons.search, color: Colors.grey),
                     filled: true,
                     fillColor: Colors.grey[100],
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8),
                       borderSide: BorderSide.none,
                     ),
                     contentPadding: const EdgeInsets.symmetric(vertical: 0),
                   ),
                 ),
                 const SizedBox(height: 12),
                 // Filters
                 SingleChildScrollView(
                   scrollDirection: Axis.horizontal,
                   child: Row(
                     children: [
                       GestureDetector(
                           onTap: () {
                               setState(() {
                                   _selectedStandard = null;
                                   _selectedYear = null;
                                   _searchController.clear();
                                   _filteredStudents = _students;
                               });
                           },
                           child: _buildFilterChip('બધા (All)', _selectedStandard == null && _selectedYear == null)
                       ),
                       const SizedBox(width: 8),
                       GestureDetector(
                           onTap: () => _showStandardFilter(),
                           child: _buildFilterChip(_selectedStandard == null ? 'ધોરણ મુજબ' : 'ધોરણ: $_selectedStandard', _selectedStandard != null, showDropdown: true)
                       ),
                       const SizedBox(width: 8),
                       GestureDetector(
                           onTap: () => _showYearFilter(),
                           child: _buildFilterChip(_selectedYear == null ? 'વર્ષ મુજબ' : 'વર્ષ: $_selectedYear', _selectedYear != null, showDropdown: true)
                       ),
                     ],
                   ),
                 )
               ],
             ),
           ),
           
           // Count & Excel Button (Secondary)
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text('વિદ્યાર્થીઓની યાદી (કુલ: ${_filteredStudents.length.toString().padLeft(2, '0').toGujaratiNumbers()})', 
                    style: GoogleFonts.notoSansGujarati(fontWeight: FontWeight.bold, fontSize: 16)
                 ),
                 ElevatedButton.icon(
                   onPressed: _exportToExcel, 
                   icon: const Icon(Icons.table_chart, size: 18, color: Color(0xFF1E8E3E)),
                   label: Text('Excel', style: GoogleFonts.publicSans(color: const Color(0xFF1E8E3E), fontWeight: FontWeight.bold)),
                   style: ElevatedButton.styleFrom(
                     backgroundColor: const Color(0xFFE6F4EA),
                     elevation: 0,
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                   ),
                 )
               ],
             ),
           ),

           // List
           Expanded(
             child: _isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : _filteredStudents.isEmpty 
                    ? const Center(child: Text('No records found'))
                    : ListView.builder(
                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                 itemCount: _filteredStudents.length,
                 itemBuilder: (context, index) {
                   return _buildStudentCard(_filteredStudents[index], index + 1);
                 },
               ),
           )
        ],
      )
    );
  }

  void _showStandardFilter() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
              return ListView(
                  shrinkWrap: true,
                  children: List.generate(8, (index) {
                      final std = (index + 1).toString();
                      return ListTile(
                          title: Text('Standard $std'),
                          onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                  _selectedStandard = std;
                                  _applyFilters();
                              });
                          },
                      );
                  }),
              );
          }
      );
  }

  void _showYearFilter() {
      // Generate last 10 years
      final currentYear = DateTime.now().year;
      final years = List.generate(10, (index) => (currentYear - index).toString());

      showModalBottomSheet(
          context: context,
          builder: (context) {
              return ListView(
                  shrinkWrap: true,
                  children: years.map((year) {
                      return ListTile(
                          title: Text(year),
                          onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                  _selectedYear = year;
                                  _applyFilters();
                              });
                          },
                      );
                  }).toList(),
              );
          }
      );
  }

  Widget _buildFilterChip(String label, bool isSelected, {bool showDropdown = false}) {
     return Container(
       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
       decoration: BoxDecoration(
         color: isSelected ? const Color(0xFF2B8CEE) : const Color(0xFFF0F2F4),
         borderRadius: BorderRadius.circular(20),
       ),
       child: Row(
         children: [
           Text(label, style: GoogleFonts.notoSansGujarati(
             color: isSelected ? Colors.white : Colors.black87,
             fontWeight: isSelected ? FontWeight.bold : FontWeight.w500
           )),
           if (showDropdown) ...[
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, size: 16, color: isSelected ? Colors.white : Colors.black87)
           ]
         ],
       )
     );
  }

  Widget _buildStudentCard(dynamic student, int index) {
    // Colors for sidebar index
    final List<Color> colors = [Colors.blue, Colors.green, Colors.purple, Colors.orange, Colors.red];
    final color = colors[index % colors.length];

    final fullName = student['fullName'] ?? student['firstName'] ?? 'Unknown';
    final grNo = (student['grNo'] ?? 0).toString().toGujaratiNumbers(); 
    
    // Admission Date instead of Leaving Date
    final admissionDate = student['admissionDate'] != null 
        ? GujaratiUtils.formatDate(DateTime.parse(student['admissionDate']))
        : 'N/A';
        
    // Previous School
    final prevSchool = student['prevSchool'] ?? 'N/A';
    
    // Index string
    final idxStr = index.toString().padLeft(2, '0').toGujaratiNumbers();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             // Left Color Bar
             Container(
               width: 6,
               decoration: BoxDecoration(
                 color: color,
                 borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))
               ),
             ),
             
             // Content
             Expanded(
               child: Padding(
                 padding: const EdgeInsets.all(12),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     // Top Row: Index + Name + GR
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         // Index Circle
                         Container(
                           width: 36, height: 36,
                           decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                           child: Center(child: Text(idxStr, style: GoogleFonts.notoSansGujarati(fontWeight: FontWeight.bold, color: Colors.grey[700]))),
                         ),
                         const SizedBox(width: 12),
                         // Name & GR
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(fullName, style: GoogleFonts.notoSansGujarati(fontSize: 16, fontWeight: FontWeight.bold)),
                               const SizedBox(height: 4),
                               Container(
                                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                 decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(4)),
                                 child: Text('GR: $grNo', style: GoogleFonts.notoSansGujarati(color: const Color(0xFF1967D2), fontWeight: FontWeight.bold, fontSize: 12)),
                               )
                             ],
                           ),
                         ),
                         // Date Column (Admission Date)
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.end,
                           children: [
                             Text('દાખલ તારીખ', style: GoogleFonts.notoSansGujarati(fontSize: 10, color: Colors.grey)),
                             Text(admissionDate, style: GoogleFonts.notoSansGujarati(fontWeight: FontWeight.bold, fontSize: 12)),
                           ],
                         )
                       ],
                     ),
                     const SizedBox(height: 12),
                     const Divider(),
                     const SizedBox(height: 8),
                     
                     // Bottom Row: Previous School
                     Row(
                       children: [
                         const Icon(Icons.school, size: 20, color: Colors.grey),
                         const SizedBox(width: 8),
                         Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('પાછલી શાળા (Previous School)', style: GoogleFonts.notoSansGujarati(fontSize: 10, color: Colors.grey)),
                                 Text(prevSchool, style: GoogleFonts.notoSansGujarati(fontWeight: FontWeight.w600, fontSize: 13), overflow: TextOverflow.ellipsis),
                               ],
                             )
                         ),
                       ],
                     )
                   ],
                 ),
               ),
             )
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String toGujaratiNumbers() {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const gujarati = ['૦', '૧', '૨', '૩', '૪', '૫', '૬', '૭', '૮', '૯'];
    String result = this;
    for (int i = 0; i < 10; i++) {
        result = result.replaceAll(english[i], gujarati[i]);
    }
    return result;
  }
}
