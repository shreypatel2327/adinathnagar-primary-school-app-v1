import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class SystemLogsScreen extends StatefulWidget {
  const SystemLogsScreen({super.key});

  @override
  State<SystemLogsScreen> createState() => _SystemLogsScreenState();
}

class _SystemLogsScreenState extends State<SystemLogsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedPeriod = 'Today / આજે';
  String? _selectedAction;
  List<dynamic> _logs = [];
  bool _isLoading = true;

  final List<String> _periods = ['Today / આજે', 'This Week / આ અઠવાડિયે', 'Month / મહિનો'];
  
  // Mapping for action filter (User friendly label -> API value)
  // Or purely frontend filter if API doesn't support perfectly? 
  // API supports 'action' param.
  // Let's assume frontend chips: "All", "Added", "Edited", "Deleted", "Notice"
  final Map<String, String> _actionFilters = {
    'Added': 'Added',
    'Edited': 'Edited', 
    'Deleted': 'Deleted',
    'Export': 'Export',
    'Notice': 'Notice'
  };

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    setState(() => _isLoading = true);
    try {
      // Build Query
      String periodParam = 'Today';
      if (_selectedPeriod.contains('Week')) periodParam = 'This Week';
      if (_selectedPeriod.contains('Month')) periodParam = 'Month';

      String url = 'http://10.0.2.2:3000/api/logs?period=$periodParam';
      if (_searchController.text.isNotEmpty) {
        url += '&search=${_searchController.text}';
      }
      if (_selectedAction != null) {
        url += '&action=$_selectedAction';
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _logs = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load logs');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error
      print(e);
    }
  }

  Color _getActionColor(String action) {
    if (action.contains('Added')) return Colors.green;
    if (action.contains('Deleted') || action.contains('Removed')) return Colors.red;
    if (action.contains('Edited')) return Colors.blue;
    if (action.contains('Export')) return Colors.purple;
    if (action.contains('Notice')) return Colors.orange;
    return Colors.grey;
  }

  IconData _getActionIcon(String action) {
    if (action.contains('Added')) return Icons.person_add;
    if (action.contains('Deleted') || action.contains('Removed')) return Icons.delete;
    if (action.contains('Edited')) return Icons.edit;
    if (action.contains('Export')) return Icons.picture_as_pdf;
    if (action.contains('Notice')) return Icons.campaign;
    if (action.contains('Backup')) return Icons.cloud_upload;
    return Icons.info;
  }

  String _formatTime(String isoString) {
    final date = DateTime.parse(isoString).toLocal();
    return DateFormat('hh:mm a').format(date);
  }
  
  String _formatDate(String isoString) {
    final date = DateTime.parse(isoString).toLocal();
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
        return 'Today';
    }
     if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
        return 'Yesterday';
    }
    return DateFormat('dd MMM').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('System Logs', style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold, color: Colors.black)),
            Text('સિસ્ટમ લૉગ્સ', style: GoogleFonts.muktaVaani(fontSize: 12, color: Colors.grey)),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.download, color: Colors.blue))
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _fetchLogs(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: 'Search User / વપરાશકર્તા શોધો',
                hintStyle: GoogleFonts.muktaVaani(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0)
              ),
            ),
          ),

          // Filter Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
               children: [
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                     decoration: BoxDecoration(
                         color: Colors.grey[100],
                         borderRadius: BorderRadius.circular(12)
                     ),
                     child: Row(
                         children: [
                             Icon(Icons.filter_list, color: Colors.grey[600], size: 20),
                             const SizedBox(width: 8),
                             Text('Filter by Action / ક્રિયા દ્વારા ફિલ્ટર કરો', style: GoogleFonts.muktaVaani(color: Colors.grey[600])),
                         ]
                     ), // Placeholder for dropdown or action sheet
                   ),
                   const SizedBox(width: 12),
                   // Action Chips could go here
               ],
            ),
          ),
          
          const SizedBox(height: 12),

          // Period Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _periods.map((period) {
                final isSelected = _selectedPeriod == period;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(period, style: GoogleFonts.muktaVaani(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                    )),
                    selected: isSelected,
                    onSelected: (bool selected) {
                        setState(() {
                            _selectedPeriod = period;
                            _fetchLogs();
                        });
                    },
                    selectedColor: const Color(0xFF2B8CEE),
                    backgroundColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text('USER / વપરાશકર્તા', style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
                    Text('ACTIVITY / પ્રવૃત્તિ', style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
                ],
            ),
          ),
          
          const Divider(height: 1),

          // List
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _logs.length,
                    separatorBuilder: (context, index) => const Divider(height: 24),
                    itemBuilder: (context, index) {
                        final log = _logs[index];
                        final user = log['user'] ?? {};
                        final userName = log['title'] ?? 'Unknown'; // Fallback to title if user null, or use title as the main display
                        // actually `title` in provided schema e.g. "Ramesh Patel"
                        
                        final action = log['actionType'] ?? 'System';
                        final description = log['description'] ?? '';
                        final time = _formatTime(log['createdAt']);
                        final date = _formatDate(log['createdAt']);
                        
                        final actionColor = _getActionColor(action);

                        return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                // Initials Avatar
                                Stack(
                                  children: [
                                    CircleAvatar(
                                        radius: 24,
                                        backgroundColor: _getAvatarColor(userName),
                                        child: Text(
                                            userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                                            style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold, color: Colors.black87)
                                        ),
                                    ),
                                    if (userName == 'Admin Office') // Example badge
                                        Positioned(
                                            bottom: 0, right: 0,
                                            child: Container(
                                                padding: const EdgeInsets.all(2),
                                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                                child: const Icon(Icons.security, size: 12, color: Colors.purple)
                                            ),
                                        )
                                  ],
                                ),
                                const SizedBox(width: 12),
                                
                                // Content
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Row(
                                                children: [
                                                    Text(userName, style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold, fontSize: 16)),
                                                    const Spacer(),
                                                    Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                        decoration: BoxDecoration(
                                                            color: actionColor.withOpacity(0.1),
                                                            borderRadius: BorderRadius.circular(4),
                                                            border: Border.all(color: actionColor.withOpacity(0.2))
                                                        ),
                                                        child: Text(action, style: GoogleFonts.muktaVaani(fontSize: 12, color: actionColor, fontWeight: FontWeight.w600)),
                                                    )
                                                ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(description, style: GoogleFonts.muktaVaani(color: Colors.grey[700], fontSize: 14)),
                                            const SizedBox(height: 4),
                                            Row(
                                                children: [
                                                    Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
                                                    const SizedBox(width: 4),
                                                    Text(date == 'Today' || date == 'Yesterday' ? '$date $time' : '$date', style: GoogleFonts.muktaVaani(color: Colors.grey[400], fontSize: 12)),
                                                ],
                                            )
                                        ],
                                    ),
                                ),
                                
                                const SizedBox(width: 12),
                                
                                // Action Icon Box
                                Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Icon(_getActionIcon(action), color: Colors.grey[600], size: 20),
                                )
                            ],
                        );
                    },
            ),
          )
        ],
      ),
    );
  }
  
  Color _getAvatarColor(String name) {
      // Generate consistent pastel color based on name
      final int hash = name.codeUnits.fold(0, (a, b) => a + b);
      final List<Color> colors = [
          Colors.orange[100]!,
          Colors.purple[100]!,
          Colors.blue[100]!,
          Colors.green[100]!,
          Colors.red[100]!,
          Colors.teal[100]!,
      ];
      return colors[hash % colors.length];
  }
}
