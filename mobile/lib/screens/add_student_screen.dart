import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/services/api_service.dart';

class AddStudentScreen extends StatefulWidget {
  final String? studentId;
  final Map<String, dynamic>? studentData;
  final int? lockedStandard; // New

  const AddStudentScreen({super.key, this.studentId, this.studentData, this.lockedStandard});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Separate keys for each tab validation
  final List<GlobalKey<FormState>> _formKeys = [
      GlobalKey<FormState>(),
      GlobalKey<FormState>(),
      GlobalKey<FormState>(),
      GlobalKey<FormState>(),
  ];

  bool _isLoading = false;
  bool _isEditMode = false;

  // Form Controllers & Values
  String? _selectedStd;
  String? _admissionOldSchoolGrNo;
  String? _admissionNewSchoolGrNo;
  final TextEditingController _prevSchoolController = TextEditingController();
  
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  String _selectedGender = 'Boy';
  String? _selectedCaste; // OBC, SC, ST, GENERAL
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _fatherEduController = TextEditingController();
  final TextEditingController _fatherOccController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _motherEduController = TextEditingController();
  final TextEditingController _motherOccController = TextEditingController();

  final TextEditingController _uidController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _nameOnAadhaarController = TextEditingController();
  final TextEditingController _rationCardController = TextEditingController();
  // final TextEditingController _fatherAadhaarController = TextEditingController();
  // final TextEditingController _motherAadhaarController = TextEditingController();
  // final TextEditingController _fatherNameOnAadhaarController = TextEditingController();
  // final TextEditingController _birthCertNameController = TextEditingController();
  // final TextEditingController _birthCertNoController = TextEditingController();

  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _bankHolderNameController = TextEditingController();

  final TextEditingController _admissionDateController = TextEditingController();
  String? _academicLevel; // Good, Medium, Ok
  String? _transportation = 'No';
  String? _isHandicapped = 'No';
  final TextEditingController _handicapPercentageController = TextEditingController();
  final TextEditingController _attendanceController = TextEditingController();
  final TextEditingController _percentageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
        if (mounted) setState(() {});
    });

    if (widget.lockedStandard != null) {
        _selectedStd = widget.lockedStandard.toString();
    }

    if (widget.studentId != null) {
        _isEditMode = true;
        if (widget.studentData != null) {
            _populateForm(widget.studentData!);
        } else {
            _fetchStudentData();
        }
    }
  }

  Future<void> _fetchStudentData() async {
      // Implement fetch if data is missing (not passed from list)
      try {
          setState(() => _isLoading = true);
          final data = await ApiService().getStudentById(widget.studentId!);
          _populateForm(data);
      } catch (e) {
         // handle error
      } finally {
          if (mounted) setState(() => _isLoading = false);
      }
  }

  void _populateForm(Map<String, dynamic> data) {
      // Standard
      String? stdVal = data['standard']?.toString();
      if (stdVal == '0') stdVal = 'Balwatika';
      const validStds = ['Balwatika', '1', '2', '3', '4', '5', '6', '7', '8'];
      _selectedStd = validStds.contains(stdVal) ? stdVal : null;
      
      _admissionOldSchoolGrNo = data['oldSchoolGrNo'];
      _admissionNewSchoolGrNo = data['newSchoolGrNo'];
      _prevSchoolController.text = data['prevSchool'] ?? '';
      
      _fullNameController.text = data['fullName'] ?? '';
      _dobController.text = data['dob']?.split('T')[0] ?? '';
      _birthPlaceController.text = data['birthPlace'] ?? '';
      _selectedGender = data['gender'] ?? 'Boy';
      
      // Caste
      String? casteVal = data['caste'];
      const validCastes = ['GENERAL', 'OBC', 'SC', 'ST'];
      _selectedCaste = validCastes.contains(casteVal) ? casteVal : null;
      
      _addressController.text = data['address'] ?? '';
      _mobileController.text = data['mobile'] ?? '';
      
      _fatherNameController.text = data['fatherName'] ?? '';
      _fatherEduController.text = data['fatherEdu'] ?? '';
      _fatherOccController.text = data['fatherOcc'] ?? '';
      _motherNameController.text = data['motherName'] ?? '';
      _motherEduController.text = data['motherEdu'] ?? '';
      _motherOccController.text = data['motherOcc'] ?? '';
      
      _uidController.text = data['uid'] ?? '';
      _aadhaarController.text = data['aadhaarNo'] ?? '';
      _nameOnAadhaarController.text = data['nameOnAadhaar'] ?? '';
      _rationCardController.text = data['rationCard'] ?? '';
      
      _bankAccountController.text = data['bankAccount'] ?? '';
      _ifscCodeController.text = data['ifscCode'] ?? '';
      _bankNameController.text = data['bankName'] ?? '';
      _bankHolderNameController.text = data['bankHolderName'] ?? '';
      
      _admissionDateController.text = data['admissionDate']?.split('T')[0] ?? '';
      
      // Result / Academic Level
      // Handle 'પાસ'/'Pass' from seed data not matching 'Good'/'Medium'
      String? res = data['result'];
      const validResults = ['Good', 'Medium', 'Weak', 'પાસ', 'નપાસ']; 
      _academicLevel = validResults.contains(res) ? res : null;
      
      _attendanceController.text = data['attendance']?.toString() ?? '';
      _percentageController.text = data['percentage']?.toString() ?? '';
      
      // Transportation
      String? trans = data['transportation'];
      if (trans != 'Yes' && trans != 'No') trans = 'No'; // Default
      _transportation = trans;
      
      // Handicapped
      String? handi = data['isHandicapped'];
      if (handi != 'Yes' && handi != 'No') handi = 'No';
      _isHandicapped = handi;
      
      _handicapPercentageController.text = data['handicapPercentage']?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Student' : 'Add New Student', style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: IgnorePointer(
                child: TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF2B8CEE),
                  unselectedLabelColor: Colors.grey,
                  labelStyle: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold),
                  isScrollable: true,
                  tabs: const [
                    Tab(text: 'Profile'),
                    Tab(text: 'Family'),
                    Tab(text: 'Govt/Bank'),
                    Tab(text: 'Academic'),
                  ],
                ),
            ),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : TabBarView(
              physics: const NeverScrollableScrollPhysics(), // Disable swipe
              controller: _tabController,
              children: [
                _buildTabWithForm(0, _buildProfileTab()),
                _buildTabWithForm(1, _buildFamilyTab()),
                _buildTabWithForm(2, _buildGovtBankTab()),
                _buildTabWithForm(3, _buildAcademicTab()),
              ],
          ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleBottomButton,
            style: ElevatedButton.styleFrom(
                backgroundColor: _isLastTab() ? Colors.green : const Color(0xFF2B8CEE)
            ),
            child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    _isLastTab() ? (_isEditMode ? 'UPDATE STUDENT' : 'SAVE STUDENT') : 'CONTINUE', 
                    style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold, color: Colors.white)
                  ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTabWithForm(int index, Widget child) {
      return Form(
          key: _formKeys[index],
          autovalidateMode: AutovalidateMode.disabled,
          child: child
      );
  }

  bool _isLastTab() {
      return _tabController.index == 3;
  }

  void _handleBottomButton() {
     // Validate current tab
     if (!_formKeys[_tabController.index].currentState!.validate()) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
             content: Text('Please correct the errors before proceeding.'),
             backgroundColor: Colors.red,
             duration: Duration(seconds: 1),
         ));
         return;
     }
  
      if (_isLastTab()) {
          _submitForm();
      } else {
          _tabController.animateTo(_tabController.index + 1);
      }
  }

  // --- TABS (Reusing build methods with improved validation logic from previous turn) ---
  
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
           IgnorePointer(
               ignoring: widget.lockedStandard != null,
               child: _buildDropdown('Standard (ધોરણ)*', ['Balwatika', '1', '2', '3', '4', '5', '6', '7', '8'], _selectedStd, (val) {
                 setState(() => _selectedStd = val);
               }, validator: (v) => v == null ? 'Required' : null),
           ),
           
           if (_shouldShowAdmissionControl()) ...[
             const SizedBox(height: 16),
             Container(
               padding: const EdgeInsets.all(12),
               decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('Admission Details', style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                   const SizedBox(height: 8),
                   Row(
                     children: [
                       Expanded(child: _buildTextField('Old School GR No', controller: TextEditingController(text: _admissionOldSchoolGrNo)..selection = TextSelection.collapsed(offset: (_admissionOldSchoolGrNo?.length ?? 0)), onChanged: (v) => _admissionOldSchoolGrNo = v)),
                       const SizedBox(width: 8),
                       Expanded(child: _buildTextField('New School GR No', controller: TextEditingController(text: _admissionNewSchoolGrNo)..selection = TextSelection.collapsed(offset: (_admissionNewSchoolGrNo?.length ?? 0)), onChanged: (v) => _admissionNewSchoolGrNo = v)),
                     ],
                   ),
                   const SizedBox(height: 8),
                   _buildTextField('Previous School Name', controller: _prevSchoolController),
                 ],
               ),
             ),
           ],

           const Divider(height: 32),
           _buildTextField('Full Name (પૂરું નામ)*', controller: _fullNameController, validator: _requiredValidator),
           const SizedBox(height: 12),
           _buildDatePicker('Date of Birth (જન્મ તારીખ)*', _dobController, validator: _requiredValidator),
           const SizedBox(height: 12),
           _buildTextField('Birth Place (જન્મ સ્થળ)*', controller: _birthPlaceController, validator: _requiredValidator),
           const SizedBox(height: 12),
           
           Row(
             children: [
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const Text('Gender'),
                     Row(
                       children: [
                         Radio(value: 'Boy', groupValue: _selectedGender, onChanged: (v) => setState(() => _selectedGender = v as String)),
                         const Text('Kumar'),
                         Radio(value: 'Girl', groupValue: _selectedGender, onChanged: (v) => setState(() => _selectedGender = v as String)),
                         const Text('Kanya'),
                       ],
                     )
                   ],
                 ),
               ),
               Expanded(child: _buildDropdown('Caste (જ્ઞાતિ)*', ['GENERAL', 'OBC', 'SC', 'ST'], _selectedCaste, (v) => setState(() => _selectedCaste = v), validator: (v) => v == null ? 'Required' : null)),
             ],
           ),
           
           const SizedBox(height: 12),
           _buildTextField('Address (સરનામું)*', controller: _addressController, maxLines: 3, validator: _requiredValidator),
           const SizedBox(height: 12),
           _buildTextField('Mobile No*', controller: _mobileController, keyboardType: TextInputType.phone, maxLength: 10, validator: (v) {
              if (v == null || v.length != 10) return 'Invalid Mobile';
              return null;
           }),
           const SizedBox(height: 60), 
        ],
      ),
    );
  }

  Widget _buildFamilyTab() {
     return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTextField('Father Name (પિતાનું નામ)*', controller: _fatherNameController, validator: _requiredValidator),
          const SizedBox(height: 12),
          _buildTextField('Father Education (પિતાનું અભ્યાસ)*', controller: _fatherEduController, validator: _requiredValidator),
          const SizedBox(height: 12),
          _buildTextField('Father Occupation (પિતાનો વ્યવસાય)*', controller: _fatherOccController, validator: _requiredValidator),
          const Divider(height: 32),
          _buildTextField('Mother Name (માતાનું નામ)*', controller: _motherNameController, validator: _requiredValidator),
          const SizedBox(height: 12),
          _buildTextField('Mother Education (માતાનું અભ્યાસ)*', controller: _motherEduController, validator: _requiredValidator),
          const SizedBox(height: 12),
          _buildTextField('Mother Occupation (માતાનો વ્યવસાય)*', controller: _motherOccController, validator: _requiredValidator),
           const SizedBox(height: 60),
        ],
      ),
     );
  }

  Widget _buildGovtBankTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Government IDs", style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildTextField('Student UID (DISE)*', controller: _uidController, validator: _requiredValidator),
          const SizedBox(height: 12),
          _buildTextField('Aadhaar No (12 Digit)*', controller: _aadhaarController, keyboardType: TextInputType.number, maxLength: 12, validator: (v) {
              if (v == null || v.length != 12) return 'Invalid Aadhaar';
              return null;
          }),
          const SizedBox(height: 12),
          _buildTextField('Name on Aadhaar*', controller: _nameOnAadhaarController, validator: _requiredValidator),
          const SizedBox(height: 12),
          _buildTextField('Ration Card No*', controller: _rationCardController, validator: _requiredValidator),
          
          const Divider(height: 32),
          Text("Bank Details (Scholarship)", style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildTextField('Bank Account No*', controller: _bankAccountController, keyboardType: TextInputType.number, validator: _requiredValidator),
          const SizedBox(height: 12),
          _buildTextField('IFSC Code*', controller: _ifscCodeController, validator: _requiredValidator),
          const SizedBox(height: 12),
          _buildTextField('Bank Name*', controller: _bankNameController, validator: _requiredValidator),
          const SizedBox(height: 12),
          _buildTextField('Name in Bank*', controller: _bankHolderNameController, validator: _requiredValidator),
           const SizedBox(height: 60),
        ],
      )
    );
  }

  Widget _buildAcademicTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDatePicker('Admission Date (દાખલ તારીખ)*', _admissionDateController, validator: _requiredValidator),
          const SizedBox(height: 12),
          _buildDropdown('Result (પરિણામ)', ['Good', 'Medium', 'Weak', 'પાસ', 'નપાસ'], _academicLevel, (v) => setState(() => _academicLevel = v)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildTextField('Attendance Days', controller: _attendanceController, keyboardType: TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField('Percentage %', controller: _percentageController, keyboardType: TextInputType.number)),
            ],
          ),
          
          const Divider(height: 32),
          _buildDropdown('Transportation?', ['Yes', 'No'], _transportation, (v) => setState(() => _transportation = v)),
          const SizedBox(height: 12),
          _buildDropdown('Is Handicapped?', ['Yes', 'No'], _isHandicapped, (v) => setState(() => _isHandicapped = v)),
          
          if (_isHandicapped == 'Yes') ...[
             const SizedBox(height: 12),
             _buildTextField('Handicap Percentage (%)', controller: _handicapPercentageController, keyboardType: TextInputType.number),
          ],
           const SizedBox(height: 60),
        ],
      ),
    );
  }

  // --- HELPERS ---

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  bool _shouldShowAdmissionControl() {
    if (_selectedStd == null) return false;
    if (_selectedStd == 'Balwatika' || _selectedStd == '1') return false;
    return true; // 2nd to 8th
  }

  Widget _buildTextField(String label, {
    TextEditingController? controller, 
    TextInputType? keyboardType, 
    int? maxLength,
    int maxLines = 1,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        counterText: "",
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged, {String? Function(String?)? validator}) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDatePicker(String label, TextEditingController controller, {String? Function(String?)? validator}) {
     return TextFormField(
       controller: controller,
       readOnly: true,
       validator: validator,
       decoration: InputDecoration(
         labelText: label,
         suffixIcon: const Icon(Icons.calendar_today),
         border: const OutlineInputBorder(),
         filled: true,
         fillColor: Colors.white,
       ),
       onTap: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            controller.text = "${picked.year}-${picked.month.toString().padLeft(2,'0')}-${picked.day.toString().padLeft(2,'0')}";
          }
       },
     );
  }

  Future<void> _submitForm() async {
    // Validation is already handled in _handleBottomButton for the active tab.
    // If you want double safety, you can validate the last tab here, but it's redundant.
      
    setState(() => _isLoading = true);
      
    final Map<String, dynamic> data = {
      'standard': _selectedStd == 'Balwatika' ? '0' : _selectedStd,
      'oldSchoolGrNo': _admissionOldSchoolGrNo,
      'newSchoolGrNo': _admissionNewSchoolGrNo,
      'prevSchool': _prevSchoolController.text,
      
      'fullName': _fullNameController.text,
      'firstName': _fullNameController.text.split(' ').first,
      'dob': _dobController.text,
      'birthPlace': _birthPlaceController.text,
      'gender': _selectedGender,
      'caste': _selectedCaste,
      'address': _addressController.text,
      'mobile': _mobileController.text,
      
      'fatherName': _fatherNameController.text,
      'fatherEdu': _fatherEduController.text,
      'fatherOcc': _fatherOccController.text,
      'motherName': _motherNameController.text,
      'motherEdu': _motherEduController.text,
      'motherOcc': _motherOccController.text,
      
      'uid': _uidController.text,
      'aadhaarNo': _aadhaarController.text,
      'nameOnAadhaar': _nameOnAadhaarController.text,
      'rationCard': _rationCardController.text,
      
      'bankAccount': _bankAccountController.text,
      'ifscCode': _ifscCodeController.text,
      'bankName': _bankNameController.text,
      'bankHolderName': _bankHolderNameController.text,
      
      'admissionDate': _admissionDateController.text,
      'result': _academicLevel,
      'attendance': _attendanceController.text.isNotEmpty ? _attendanceController.text : null,
      'percentage': _percentageController.text.isNotEmpty ? _percentageController.text : null,
      
      'transportation': _transportation,
      'isHandicapped': _isHandicapped,
      'handicapPercentage': _handicapPercentageController.text.isNotEmpty ? _handicapPercentageController.text : null,
    };

    try {
      final api = ApiService();
      if (_isEditMode) {
          await api.updateStudent(widget.studentId!, data);
          if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student Updated Successfully!')));
              context.pop();
          }
      } else {
          await api.createStudent(data);
          if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student Added Successfully!')));
              context.pop();
          }
      }

    } catch (e) {
      if (mounted) {
           _parseAndShowError(e.toString());
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _parseAndShowError(String errorString) {
      String message = "An error occurred";
      
      // Try to extract JSON from the error string (e.g. "Exception: { ... }")
      // The backend returns { error: "Validation Failed", details: { field: { _errors: ["msg"] } } }
      try {
          // Remove "Exception: " prefix if present
          String jsonStr = errorString.replaceAll('Exception:', '').trim();
          
          // If it looks like JSON
          if (jsonStr.startsWith('{') && jsonStr.endsWith('}')) {
              // We need to decode it manually or find a way, but since we are in Dart, 
              // we can try to assume the structure if we can't import valid JSON decoder easily inside this snippet without regex, 
              // BUT we can use standard jsonDecode from 'dart:convert' (assuming it's imported via api_service or we add it).
              // Ideally ApiService should have thrown a structured exception.
              // For now, let's try a regex approach or basic string parsing to be safe if imports are tricky in this replace block (they are not, but let's be robust).
              
              // Actually, simply showing the clean text is better.
              // Let's assume the user gets "Failed to create student: {...}"
              // We can regex for "details":{...}
              
              if (jsonStr.contains("Validation Failed")) {
                  message = "Please check the following fields:\n";
                  
                  // Extract simplified field errors (Regex is risky for JSON, but better than raw)
                  // Let's look for: "fullName":{"_errors":["Full name is required"]}
                  // Regex: "(\w+)":\{"_errors":\["([^"]+)"\]\}
                  
                  final regex = RegExp(r'"(\w+)":\{"_errors":\["([^"]+)"\]\}');
                  final matches = regex.allMatches(jsonStr);
                  
                  if (matches.isNotEmpty) {
                      for (final match in matches) {
                          // match.group(2) is the error message
                          message += "• ${match.group(2)}\n";
                      }
                  } else {
                       message += "Invalid data provided.";
                  }
              } else {
                  message = jsonStr; // Fallback
              }
          } else {
              message = jsonStr;
          }
      } catch (_) {
          message = errorString;
      }

      showDialog(
        context: context, 
        builder: (c) => AlertDialog(
          title: const Text("Error Saving Student"),
          content: SingleChildScrollView(child: Text(message)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c), child: const Text("OK"))
          ],
        )
      );
  }
}
