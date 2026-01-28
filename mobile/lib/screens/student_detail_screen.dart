import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/services/api_service.dart';

class StudentDetailScreen extends StatefulWidget {
  final String studentId;
  const StudentDetailScreen({super.key, required this.studentId});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _student;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchStudentDetails();
  }

  Future<void> _fetchStudentDetails() async {
    try {
      final student = await _apiService.getStudentById(widget.studentId);
      if (mounted) {
        setState(() {
          _student = student;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteStudent() async {
      final confirm = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
              title: const Text('Delete Student?'),
              content: const Text('Are you sure you want to delete this student? This action cannot be undone.'),
              actions: [
                  TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                  TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
              ],
          )
      );

      if (confirm == true) {
          try {
              await _apiService.deleteStudent(widget.studentId);
              if (mounted) {
                  context.go('/students'); // Go back to list
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student Deleted')));
              }
          } catch (e) {
              if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
          }
      }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_errorMessage.isNotEmpty) return Scaffold(body: Center(child: Text(_errorMessage)));
    if (_student == null) return const Scaffold(body: Center(child: Text("Student not found")));

    final s = _student!;

    return Scaffold(
      appBar: AppBar(
        title: Text(s['fullName'] ?? 'Details'),
        actions: [
            IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                     // Navigate to Edit Mode
                     await context.push('/students/edit/${widget.studentId}', extra: s);
                     _fetchStudentDetails();
                },
            ),
            IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: _deleteStudent,
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                _buildSection("Admission Details", [
                    _buildRow("Standard", s['standard'].toString() == '0' ? 'Balwatika' : s['standard'].toString()),
                    _buildRow("Old School GR No", s['oldSchoolGrNo']),
                    _buildRow("New School GR No", s['newSchoolGrNo']),
                    _buildRow("Previous School", s['prevSchool']),
                    _buildRow("Admission Date", s['admissionDate']?.toString().split('T')[0]),
                ]),
                _buildSection("Personal Details", [
                    _buildRow("Full Name", s['fullName']),
                    _buildRow("Date of Birth", s['dob']?.toString().split('T')[0]),
                    _buildRow("Birth Place", s['birthPlace']),
                    _buildRow("Gender", s['gender']),
                    _buildRow("Caste", s['caste']),
                    _buildRow("Address", s['address']),
                    _buildRow("Mobile", s['mobile']),
                ]),
                _buildSection("Family Details", [
                    _buildRow("Father Name", s['fatherName']),
                    _buildRow("Father Education", s['fatherEdu']),
                    _buildRow("Father Occupation", s['fatherOcc']),
                    const SizedBox(height: 8),
                    _buildRow("Mother Name", s['motherName']),
                    _buildRow("Mother Education", s['motherEdu']),
                    _buildRow("Mother Occupation", s['motherOcc']),
                ]),
                _buildSection("Government IDs", [
                    _buildRow("UID (DISE)", s['uid']),
                    _buildRow("Aadhaar No", s['aadhaarNo']),
                    _buildRow("Name on Aadhaar", s['nameOnAadhaar']),
                    _buildRow("Ration Card", s['rationCard']),
                ]),
                _buildSection("Bank Details", [
                    _buildRow("Bank Name", s['bankName']),
                    _buildRow("Account No", s['bankAccount']),
                    _buildRow("IFSC Code", s['ifscCode']),
                    _buildRow("Holder Name", s['bankHolderName']),
                ]),
                _buildSection("Academic Info", [
                    _buildRow("Result Level", s['result']),
                    _buildRow("Attendance Days", s['attendance']?.toString()),
                    _buildRow("Percentage", s['percentage']?.toString()),
                ]),
                _buildSection("Other", [
                    _buildRow("Transportation", s['transportation']),
                    _buildRow("Handicapped", s['isHandicapped']),
                    if (s['isHandicapped'] == 'Yes')
                        _buildRow("Handicap %", s['handicapPercentage']?.toString()),
                ]),
            ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text(title, style: GoogleFonts.muktaVaani(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
              const Divider(),
              ...children,
              const SizedBox(height: 20),
          ],
      );
  }

  Widget _buildRow(String label, String? value) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
              children: [
                  SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey))),
                  Expanded(child: Text(value ?? '-', style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
          ),
      );
  }
}
