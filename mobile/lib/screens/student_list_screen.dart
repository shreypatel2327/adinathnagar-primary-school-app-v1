import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/services/api_service.dart';

class StudentListScreen extends StatefulWidget {
  final String? initialSearch;
  final int? lockedStandard; // New: If provided, locks the standard filter

  const StudentListScreen({super.key, this.initialSearch, this.lockedStandard});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _students = [];
  List<dynamic> _filteredStudents = [];
  bool _isLoading = true;
  String _errorMessage = '';
  
  final TextEditingController _searchController = TextEditingController();
  
  // Filters
  String? _selectedStandard;
  String? _selectedGender; // 'Boy', 'Girl'

  @override
  void initState() {
    super.initState();
    if (widget.initialSearch != null) {
        _searchController.text = widget.initialSearch!;
    }
    // Lock standard if provided
    if (widget.lockedStandard != null) {
        _selectedStandard = widget.lockedStandard.toString();
    }
    _fetchStudents();
    _searchController.addListener(_applyFilters);
  }

  Future<void> _fetchStudents() async {
    try {
      final students = await _apiService.getStudents();
      if (mounted) {
        setState(() {
          _students = students;
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
          _filteredStudents = _students.where((student) {
              final name = (student['fullName'] ?? student['firstName'] ?? '').toString().toLowerCase();
              final gr = (student['grNo'] ?? '').toString();
              final mobile = (student['mobile'] ?? '').toString();
              
              final matchesSearch = name.contains(query) || gr.contains(query) || mobile.contains(query);
              
              final std = (student['standard'] ?? '').toString();
              // Fix: If lockedStandard is set, only match that. Otherwise use selected or match all.
              final effectiveStandard = widget.lockedStandard?.toString() ?? _selectedStandard;
              final matchesStandard = effectiveStandard == null || std == effectiveStandard;
              
              final gender = (student['gender'] ?? '').toString(); // 'Boy' or 'Girl' or 'Kum'/'Kan'
              bool matchesGender = true;
              if (_selectedGender == 'Boy') {
                  matchesGender = gender.toLowerCase().contains('boy') || gender.contains('કુમાર');
              } else if (_selectedGender == 'Girl') {
                  matchesGender = gender.toLowerCase().contains('girl') || gender.contains('કન્યા');
              }
              
              return matchesSearch && matchesStandard && matchesGender;
          }).toList();
          
          // Sort by GR No (Assuming Int)
          _filteredStudents.sort((a, b) {
             int grA = int.tryParse(a['grNo'].toString()) ?? 0;
             int grB = int.tryParse(b['grNo'].toString()) ?? 0;
             return grA.compareTo(grB);
          });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111418)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'વિદ્યાર્થીઓ (Students)',
          style: GoogleFonts.muktaVaani(
            color: const Color(0xFF111418),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF2B8CEE)),
            onPressed: () {
                setState(() => _isLoading = true);
                _fetchStudents();
            },
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
              : Column(
        children: [
            // Search Bar & Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                    TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                        hintText: 'Search by Name or GR No...',
                        hintStyle: GoogleFonts.muktaVaani(color: const Color(0xFF617589)),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF617589)),
                        filled: true,
                        fillColor: const Color(0xFFF0F2F4),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
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
                                    onTap: () => setState(() { 
                                        // Only clear standard if not locked
                                        if (widget.lockedStandard == null) {
                                            _selectedStandard = null; 
                                        }
                                        _selectedGender = null; 
                                        _applyFilters(); 
                                    }),
                                    child: _buildFilterChip('All Students', 
                                        ((widget.lockedStandard == null && _selectedStandard == null) || 
                                         (widget.lockedStandard != null && _selectedStandard == widget.lockedStandard.toString())) 
                                        && _selectedGender == null)
                                ),
                                const SizedBox(width: 8),
                                if (widget.lockedStandard == null) ...[
                                    GestureDetector(
                                        onTap: _showStandardFilter,
                                        child: _buildFilterChip(_selectedStandard == null ? 'Standard' : 'Std $_selectedStandard', _selectedStandard != null, showDropdown: true)
                                    ),
                                    const SizedBox(width: 8),
                                ],
                                GestureDetector(
                                    onTap: () => setState(() {  
                                        _selectedGender = (_selectedGender == 'Boy') ? null : 'Boy'; 
                                        _applyFilters(); 
                                    }),
                                    child: _buildFilterChip('Boy (કુમાર)', _selectedGender == 'Boy')
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                    onTap: () => setState(() { 
                                        _selectedGender = (_selectedGender == 'Girl') ? null : 'Girl'; 
                                        _applyFilters(); 
                                    }),
                                    child: _buildFilterChip('Girl (કન્યા)', _selectedGender == 'Girl')
                                ),
                            ],
                        ),
                    )
                ],
              ),
            ),
            
            // Student List
            Expanded(
              child: _filteredStudents.isEmpty 
                  ? const Center(child: Text('No students found')) 
                  : RefreshIndicator(
                    onRefresh: _fetchStudents,
                    child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredStudents.length,
                    itemBuilder: (context, index) {
                        final student = _filteredStudents[index];
                        return _buildStudentCard(student);
                    },
                    ),
                ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
            await context.push('/students/add');
            _fetchStudents();
        },
        backgroundColor: const Color(0xFF2B8CEE),
        child: const Icon(Icons.add, color: Colors.white),
      ),
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

  Widget _buildFilterChip(String label, bool isSelected, {bool showDropdown = false}) {
     return Container(
       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
       decoration: BoxDecoration(
         color: isSelected ? const Color(0xFF2B8CEE) : const Color(0xFFF0F2F4),
         borderRadius: BorderRadius.circular(20),
       ),
       child: Row(
         children: [
           Text(label, style: GoogleFonts.muktaVaani(
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

  Widget _buildStudentCard(dynamic student) {
      final String fullName = student['fullName'] ?? student['firstName'] ?? 'Unknown';
      final String initials = (student['firstName'] as String? ?? 'S').substring(0, 1).toUpperCase();
      final String category = student['category'] ?? 'General';
      final String mobile = student['mobile'] ?? 'N/A';
      final int grNo = student['grNo'] ?? 0;

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar (Initials for now)
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)
                    ]
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: GoogleFonts.muktaVaani(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _getCategoryTextColor(category),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: GoogleFonts.muktaVaani(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF111418),
                        ),
                      ),
                      const SizedBox(height: 4),
                       Row(
                        children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color:  const Color(0xFFE8F0FE),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'GR: $grNo',
                                style: GoogleFonts.muktaVaani(
                                  fontSize: 12,
                                  color: const Color(0xFF1967D2),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.call, size: 14, color: const Color(0xFF617589)),
                            const SizedBox(width: 4),
                            Text(
                              mobile,
                              style: GoogleFonts.muktaVaani(
                                fontSize: 13,
                                color: const Color(0xFF617589),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),
            
            // Actions
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // View Button
                  IconButton(
                    onPressed: () async {
                         await context.push('/students/detail/${student['id']}');
                         _fetchStudents();
                    }, 
                    icon: const Icon(Icons.visibility_outlined, color: Color(0xFF2B8CEE)),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF2B8CEE).withOpacity(0.1),
                    ),
                    tooltip: 'View Details',
                  ),
                  const SizedBox(width: 8),
                  // Bonafide Button
                  if (widget.lockedStandard == null) ...[
                      IconButton(
                        onPressed: () {
                             context.push('/students/certificate/bonafide/${student['id']}', extra: student);
                        }, 
                        icon: const Icon(Icons.card_membership, color: Colors.orange),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.orange.withOpacity(0.1),
                        ),
                        tooltip: 'Bonafide Certificate',
                      ),
                      const SizedBox(width: 8),
                      // Vali Form Button
                      IconButton(
                        onPressed: () {
                             context.push('/students/certificate/vali/${student['id']}', extra: student);
                        }, 
                        icon: const Icon(Icons.description_outlined, color: Colors.purple),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.purple.withOpacity(0.1),
                        ),
                        tooltip: 'Vali Form',
                      ),
                      const SizedBox(width: 8),
                  ],
                  // Edit Button
                  IconButton(
                    onPressed: () async {
                         await context.push('/students/edit/${student['id']}', extra: student);
                         _fetchStudents();
                    }, 
                    icon: const Icon(Icons.edit_outlined, color: Color(0xFF617589)),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                    ),
                    tooltip: 'Edit Student',
                  ),
                  const SizedBox(width: 8),
                  // Javak / Remove Button
                  if (widget.lockedStandard == null)
                  IconButton(
                    onPressed: () => _showJavakDialog(context, student),
                    icon: const Icon(Icons.person_remove_outlined, color: Colors.red),
                     style: IconButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.1),
                    ),
                    tooltip: 'Remove Student (Javak)',
                  ),
                ],
            )
          ],
        ),
      );
  }

   Color _getCategoryColor(String category) {
    if (category.toLowerCase().contains('sc')) return Colors.pink[50]!;
    if (category.toLowerCase().contains('st')) return Colors.orange[50]!;
    if (category.toLowerCase().contains('obc')) return Colors.purple[50]!;
    return Colors.blue[50]!;
  }

  Color _getCategoryTextColor(String category) {
    if (category.toLowerCase().contains('sc')) return Colors.pink[700]!;
    if (category.toLowerCase().contains('st')) return Colors.orange[700]!;
    if (category.toLowerCase().contains('obc')) return Colors.purple[700]!;
    return Colors.blue[700]!;
  }

  void _showJavakDialog(BuildContext context, dynamic student) {
    final TextEditingController schoolController = TextEditingController();
    final TextEditingController remarksController = TextEditingController();
    final TextEditingController dateController = TextEditingController(); // For display
    DateTime? selectedDate = DateTime.now(); // Default today

    // Format for display: DD/MM/YYYY
    String formatDate(DateTime d) => "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
    dateController.text = formatDate(selectedDate!);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Center(
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle),
                    child: const Icon(Icons.person_remove, color: Colors.red, size: 32)
                ),
                const SizedBox(height: 10),
                Text('વિદ્યાર્થી કમી કરો', style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold, fontSize: 22)),
                Text('કૃપા કરીને નીચેની વિગતો ભરો', style: GoogleFonts.muktaVaani(fontSize: 14, color: Colors.grey)),
              ],
            )
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text('જનાર શાળાનું નામ', style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold)),
                 const SizedBox(height: 5),
                 TextField(
                   controller: schoolController,
                   decoration: InputDecoration(
                     hintText: 'શાળાનું નામ લખો...',
                     hintStyle: GoogleFonts.muktaVaani(color: Colors.grey),
                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                   ),
                 ),
                 const SizedBox(height: 16),
            
                 Text('કમી કર્યા તારીખ', style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold)),
                 const SizedBox(height: 5),
                 TextField(
                   controller: dateController,
                   readOnly: true,
                   decoration: InputDecoration(
                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                     suffixIcon: const Icon(Icons.calendar_today),
                   ),
                   onTap: () async {
                     final DateTime? picked = await showDatePicker(
                       context: context,
                       initialDate: selectedDate ?? DateTime.now(),
                       firstDate: DateTime(2000),
                       lastDate: DateTime(2030),
                     );
                     if (picked != null) {
                       selectedDate = picked;
                       dateController.text = formatDate(picked);
                     }
                   },
                 ),
                 const SizedBox(height: 16),

                 Text('રિમાર્ક (Remarks)', style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold)),
                 const SizedBox(height: 5),
                 TextField(
                   controller: remarksController,
                   decoration: InputDecoration(
                     hintText: 'રિમાર્ક લખો...',
                     hintStyle: GoogleFonts.muktaVaani(color: Colors.grey),
                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                   ),
                 ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      side: BorderSide(color: Colors.grey.shade300)
                    ),
                    child: Text('રદ કરો', style: GoogleFonts.muktaVaani(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                       if (schoolController.text.isEmpty || selectedDate == null || remarksController.text.isEmpty) {
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields (School, Date, Remarks)')));
                         return;
                       }
                       
                       try {
                         // Call API
                         await _apiService.markStudentAsJavak(student['id'], schoolController.text, selectedDate!, remarksController.text);
                         if (context.mounted) {
                           Navigator.pop(context); // Close dialog
                           _fetchStudents(); // Refresh list
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student marked as Javak successfully')));
                         }
                       } catch (e) {
                         if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                         }
                       }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B8CEE),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('પુષ્ટિ કરો', style: GoogleFonts.muktaVaani(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ],
        );
      }
    );
  }
}
