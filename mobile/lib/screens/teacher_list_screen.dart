
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/services/api_service.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});

  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _teachers = [];
  List<dynamic> _filteredTeachers = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();
  int _selectedTab = 0; // 0: All, 1: 1-5, 2: 6-8

  @override
  void initState() {
    super.initState();
    _fetchTeachers();
    _searchController.addListener(_applyFilters);
  }

  Future<void> _fetchTeachers() async {
    try {
      final teachers = await _apiService.getTeachers();
      if (mounted) {
        setState(() {
          _teachers = teachers;
          _isLoading = false;
          _applyFilters();
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

  void _applyFilters() {
     final query = _searchController.text.toLowerCase();
     setState(() {
       _filteredTeachers = _teachers.where((t) {
         final name = (t['fullName'] ?? '').toString().toLowerCase();
         final username = (t['username'] ?? '').toString().toLowerCase();
         final matchSearch = name.contains(query) || username.contains(query);
         
         if (!matchSearch) return false;

         // Tab Filter
         if (_selectedTab == 0) return true;
         
         final stdStr = (t['standard'] ?? '').toString(); 
         // Logic for 1-5 vs 6-8. Assuming standard is "1", "2"... 
         // If standard is "1-5", "6-8" string, we check match.
         // If it's single number, we check range.
         
         int? std = int.tryParse(stdStr);
         if (std != null) {
            if (_selectedTab == 1) return std >= 1 && std <= 5;
            if (_selectedTab == 2) return std >= 6 && std <= 8;
         } else {
             // String match fallback
             if (_selectedTab == 1 && (stdStr.contains("1-5") || stdStr.contains("1") || stdStr.contains("2") || stdStr.contains("3") || stdStr.contains("4") || stdStr.contains("5"))) return true;
             if (_selectedTab == 2 && (stdStr.contains("6-8") || stdStr.contains("6") || stdStr.contains("7") || stdStr.contains("8"))) return true;
         }
         return false;
       }).toList();
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(
        title: Text(
            'શિક્ષકોનું સંચાલન', // Manage Teachers
            style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold, color: Colors.black)
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
            onPressed: () => context.pop(),
        ),
        actions: [
            IconButton(icon: const Icon(Icons.more_horiz, color: Colors.blue), onPressed: (){})
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
          children: [
            // Search
            Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        hintText: 'શિક્ષક શોધો...', // Search Teacher...
                        hintStyle: GoogleFonts.muktaVaani(color: Colors.grey),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                         filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200)
                        ),
                         enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200)
                        ),
                    ),
                ),
            ),
            
            // Tabs
            Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                    children: [
                        _buildTabButton('બધા શિક્ષકો', 0), // All Teachers
                        const SizedBox(width: 8),
                        _buildTabButton('ધોરણ ૧-૫', 1), // Std 1-5
                        const SizedBox(width: 8),
                        _buildTabButton('ધોરણ ૬-૮', 2), // Std 6-8
                    ],
                ),
            ),
            
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredTeachers.length,
                    itemBuilder: (context, index) {
                        return _buildTeacherCard(_filteredTeachers[index]);
                    },
                )
            )
          ],
        ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF2B8CEE),
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () async {
              await context.push('/teachers/add');
              _fetchTeachers();
          },
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
      final isSelected = _selectedTab == index;
      return GestureDetector(
          onTap: () => setState(() { _selectedTab = index; _applyFilters(); }),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2B8CEE) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected ? null : Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                  text,
                  style: GoogleFonts.muktaVaani(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.w500
                  ),
              ),
          ),
      );
  }

  Widget _buildTeacherCard(dynamic teacher) {
      final String name = teacher['fullName'] ?? teacher['username'];
      final String std = teacher['standard'] != null ? 'ધોરણ ${teacher['standard']}' : 'Not Assigned';
      final bool isActive = teacher['isActive'] ?? true;
      
      return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
              children: [
                   Container(
                     width: 56,
                     height: 56,
                     decoration: BoxDecoration(
                       color: Colors.blue[50],
                       shape: BoxShape.circle,
                       border: Border.all(color: Colors.white, width: 2),
                       boxShadow: [
                           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)
                       ]
                     ),
                     child: Center(
                       child: Text(
                         name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'T',
                         style: GoogleFonts.muktaVaani(
                             fontSize: 20,
                             fontWeight: FontWeight.bold,
                             color: Colors.blue[700],
                         ),
                       ),
                     ),
                   ),
                   const SizedBox(width: 16),
                   Expanded(
                       child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                               Text(name, style: GoogleFonts.muktaVaani(fontSize: 16, fontWeight: FontWeight.bold)),
                               const SizedBox(height: 4),
                               Row(
                                   children: [
                                       Text(std, style: GoogleFonts.muktaVaani(color: Colors.grey)),
                                       const SizedBox(width: 8),
                                       Container(
                                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                           decoration: BoxDecoration(
                                               color: isActive ? Colors.green[50] : Colors.red[50],
                                               borderRadius: BorderRadius.circular(4)
                                           ),
                                           child: Text(
                                               isActive ? 'કાર્યરત' : 'Inactive', 
                                               style: GoogleFonts.muktaVaani(
                                                   fontSize: 12, 
                                                   color: isActive ? Colors.green : Colors.red, 
                                                   fontWeight: FontWeight.bold
                                               )
                                           ),
                                       )
                                   ],
                               )
                           ],
                       ),
                   ),
                   IconButton(
                       icon: const Icon(Icons.edit_square, color: Color(0xFF2B8CEE)),
                       onPressed: () async {
                           await context.push('/teachers/edit/${teacher['id']}', extra: teacher);
                           _fetchTeachers();
                       },
                   )
              ],
          ),
      );
  }
}
