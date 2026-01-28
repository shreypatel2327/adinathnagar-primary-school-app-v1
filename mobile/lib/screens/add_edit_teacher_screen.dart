
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/services/api_service.dart';

class AddEditTeacherScreen extends StatefulWidget {
  final String? teacherId;
  final Map<String, dynamic>? teacherData;

  const AddEditTeacherScreen({super.key, this.teacherId, this.teacherData});

  @override
  State<AddEditTeacherScreen> createState() => _AddEditTeacherScreenState();
}

class _AddEditTeacherScreenState extends State<AddEditTeacherScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedStandard;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.teacherData != null) {
      _populateData(widget.teacherData!);
    }
  }

  void _populateData(Map<String, dynamic> data) {
    _fullNameController.text = data['fullName'] ?? '';
    _usernameController.text = data['username'] ?? '';
    // Typically backend won't send password, or hash. Assuming blank for edit if not changed.
    // data['password'] usually masked.
    _selectedStandard = data['standard'];
    _isActive = data['isActive'] ?? true;
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.teacherId != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7F8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEdit ? 'શિક્ષક સુધારો' : 'શિક્ષક ઉમેરો', // Update / Add
          style: GoogleFonts.muktaVaani(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('શિક્ષકનું પૂરું નામ'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fullNameController,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    decoration: _inputDecoration('નામ દાખલ કરો'), // Enter Name
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('વપરાશકર્તા નામ'), // Username
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _usernameController,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    decoration: _inputDecoration('વપરાશકર્તા નામ દાખલ કરો'),
                  ),
                  const SizedBox(height: 20),
                  
                  _buildLabel('પાસવર્ડ'), // Password
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    validator: (v) {
                         if (!isEdit && (v == null || v.isEmpty)) return 'Required';
                         return null;
                    },
                    decoration: _inputDecoration('પાસવર્ડ દાખલ કરો').copyWith(
                        suffixIcon: IconButton(
                             icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                             onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        )
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  _buildLabel('નિર્ધારિત ધોરણ'), // Standard
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                      value: _selectedStandard,
                      decoration: _inputDecoration('ધોરણ પસંદ કરો'),
                      items: List.generate(8, (i) => (i+1).toString()).map((e) => DropdownMenuItem(value: e, child: Text('Standard $e'))).toList(), 
                      onChanged: (v) => setState(() => _selectedStandard = v),
                      validator: (v) => v == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  
                  // Status
                  Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300)
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                               Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                       Text(
                                           'સ્થિતિ', // Status
                                           style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold, fontSize: 16)
                                       ),
                                       Text(
                                           _isActive ? 'સક્રિય' : 'નિષ્ક્રિય', // Active / Inactive
                                           style: GoogleFonts.muktaVaani(color: Colors.grey)
                                       )
                                   ],
                               ),
                               Switch(
                                   value: _isActive,
                                   onChanged: (v) => setState(() => _isActive = v),
                                   activeColor: const Color(0xFF2B8CEE),
                               )
                          ],
                      ),
                  )
                ],
              ),
            ),
          ),
      bottomSheet: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: SizedBox(
             width: double.infinity,
             height: 48,
             child: ElevatedButton(
                 onPressed: _submit,
                 style: ElevatedButton.styleFrom(
                     backgroundColor: const Color(0xFF2B8CEE),
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                 ),
                 child: Text(
                     'સેવ કરો', 
                     style: GoogleFonts.muktaVaani(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                 ),
             ),
          ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
      return InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.muktaVaani(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)
      );
  }

  Widget _buildLabel(String text) {
      return Text(
          text,
          style: GoogleFonts.muktaVaani(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: const Color(0xFF111418)
          )
      );
  }

  Future<void> _submit() async {
      if (!_formKey.currentState!.validate()) return;
      
      setState(() => _isLoading = true);
      
      final data = {
          'fullName': _fullNameController.text,
          'username': _usernameController.text,
          'standard': _selectedStandard,
          'isActive': _isActive,
      };
      
      if (_passwordController.text.isNotEmpty) {
          data['password'] = _passwordController.text;
      }
      
      try {
          if (widget.teacherId != null) {
              await _apiService.updateTeacher(widget.teacherId!, data);
          } else {
              if (_passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password is required for new accounts')));
                   setState(() => _isLoading = false);
                   return;
              }
              await _apiService.createTeacher(data);
          }
           if (mounted) {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved Successfully')));
               context.pop();
           }
      } catch (e) {
         if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
         }
      } finally {
          if (mounted) setState(() => _isLoading = false);
      }
  }
}
