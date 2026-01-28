import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/services/api_service.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  int _totalStudents = 0;
  
  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
      // In a real app we'd have a specific endpoint for teacher stats
      // For now, let's fetch students and filter (inefficient but works for prototype)
      // Or relies on dashboard/stats if it supports standard filtering
      // Let's assume we fetch all students and count for now since dashboard/stats returns defaults
      try {
          final students = await _apiService.getStudents();
          final std = AuthService().assignedStandard;
          if (std != null) {
              final count = students.where((s) => s['standard'] == std && s['status'] == 'Active').length;
              setState(() {
                  _totalStudents = count;
                  _isLoading = false;
              });
          } else {
              setState(() => _isLoading = false);
          }
      } catch (e) {
          setState(() => _isLoading = false);
          print("Error fetching teacher stats: $e");
      }
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService().isLoggedIn) {
        // Redirection should happen via router redirect but as failsafe:
        Future.microtask(() => context.go('/login'));
        return const Scaffold();
    }
    
    final user = AuthService().currentUser!;
    final name = user['fullName'] ?? user['username'];
    final standard = user['standard'] ?? 'Not Assigned';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(
        title: Text('Dashboard', style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Builder(builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
        )),
        actions: [
            IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black), onPressed: () {})
        ],
      ),
      drawer: Drawer(
          child: ListView(
              children: [
                  UserAccountsDrawerHeader(
                      accountName: Text(name),
                      accountEmail: Text('Class Teacher: Std $standard'),
                      currentAccountPicture: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(name[0].toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      decoration: const BoxDecoration(color: Color(0xFF2B8CEE)),
                  ),
                   ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () {
                          AuthService().logout();
                          context.go('/login');
                      },
                  )
              ],
          ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)
                ),
                child: Row(
                    children: [
                        CircleAvatar(
                            radius: 30,
                            backgroundImage: const NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAGGwQl1JGjyZECDJZab8DbjZpxrOs2LRuo83buYz0ZiqZHQWAg6qTp5E8ZQbUx2M4LiIN-Ygb0PQtKThovotGGWr2AqYJfIodKaQ18p-M9BmLkSOmFAVcRt_EJoEkgs9yNEOERS6tnxpKVyNEi3nolXS1IwSbMp1ws_WaN2mA7YbrJ0L2ZMNTUYfteifE8r2-BHpE7CryhpNp0ERiZ-RQ30NEAKhQdqGIQzuyA_YkjzEAzqAgRJyUobR8REZmxAg4JFun539Ns4oM'), // Placeholder or Initials
                        ),
                        const SizedBox(width: 16),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text('Namaste, ${name.split(' ')[0]}', style: GoogleFonts.muktaVaani(fontSize: 18, fontWeight: FontWeight.bold)),
                                Text('Class Teacher: Std $standard', style: GoogleFonts.muktaVaani(color: Colors.blue[700], fontWeight: FontWeight.w500)),
                                Text('વર્ગ શિક્ષક: ધોરણ $standard', style: GoogleFonts.muktaVaani(fontSize: 12, color: Colors.blue[700])),
                            ],
                        )
                    ],
                ),
            ),
            
            const SizedBox(height: 24),
            Text('Overview (ઝાંખી)', style: GoogleFonts.muktaVaani(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            // Stats Card
            Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
                                    child: const Icon(Icons.school, color: Colors.blue),
                                ),
                                Icon(Icons.groups, size: 48, color: Colors.blue[50])
                            ],
                        ),
                        const SizedBox(height: 16),
                        Text('Total Students', style: GoogleFonts.muktaVaani(color: Colors.grey[600])),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                                Text(_isLoading ? '...' : '$_totalStudents', style: GoogleFonts.muktaVaani(fontSize: 32, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                Text('(કુલ વિદ્યાર્થીઓ)', style: GoogleFonts.muktaVaani(color: Colors.grey)),
                            ],
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(value: 0.85, backgroundColor: Colors.blue[50], color: Colors.blue, borderRadius: BorderRadius.circular(4)), // Dummy value for UI
                        const SizedBox(height: 8),
                         Text('85% Attendance Today', style: GoogleFonts.muktaVaani(fontSize: 12, color: Colors.grey)),
                    ],
                ),
            ),
            
            const SizedBox(height: 24),
            Text('Quick Actions (ઝડપી ક્રિયાઓ)', style: GoogleFonts.muktaVaani(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            Row(
                children: [
                    Expanded(
                        child: _buildActionCard(
                            icon: Icons.person_add,
                            label: 'Add Student',
                            subLabel: 'વિદ્યાર્થી ઉમેરો',
                            color: Colors.blue,
                            onTap: () async {
                                final std = AuthService().assignedStandard;
                                await context.push('/students/add', extra: {'lockedStandard': std});
                                _fetchStats(); // Refresh after return
                            } 
                        ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                        child: _buildActionCard(
                            icon: Icons.list_alt,
                            label: 'Class List',
                            subLabel: 'વર્ગ યાદી',
                            color: Colors.purple,
                            onTap: () async {
                                final std = AuthService().assignedStandard;
                                await context.push('/students?lockedStandard=$std');
                                _fetchStats();
                            }
                        ),
                    ),
                ],
            ),
            
             const SizedBox(height: 24),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text('Notices (સૂચનાઓ)', style: GoogleFonts.muktaVaani(fontSize: 18, fontWeight: FontWeight.bold)),
                     Text('View All', style: GoogleFonts.muktaVaani(color: Colors.blue, fontWeight: FontWeight.bold)),
                ],
            ),
             const SizedBox(height: 12),
             
             Container(
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(16),
                     border: Border(left: BorderSide(color: Colors.blue, width: 4))
                 ),
                 child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                         Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                                 Text('Diwali Vacation Update', style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold)),
                                 Container(
                                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                     decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
                                     child: Text('Today', style: GoogleFonts.muktaVaani(fontSize: 10)),
                                 )
                             ],
                         ),
                         const SizedBox(height: 8),
                         Text('School will remain closed from Oct 28th for Diwali vacation. (દિવાળી વેકેશન માટે શાળા બંધ રહેશે.)', style: GoogleFonts.muktaVaani(color: Colors.grey[600], fontSize: 13)),
                     ],
                 ),
             )
            
          ],
        ),
      ),
       bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2B8CEE),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.muktaVaani(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.muktaVaani(fontSize: 12, fontWeight: FontWeight.w500),
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Students'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Schedule'), // Placeholder
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildActionCard({required IconData icon, required String label, required String subLabel, required Color color, required VoidCallback onTap}) {
      return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
                  ]
              ),
              child: Column(
                  children: [
                      Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle
                          ),
                          child: Icon(icon, color: color, size: 28),
                      ),
                      const SizedBox(height: 16),
                      Text(label, style: GoogleFonts.muktaVaani(fontWeight: FontWeight.bold, fontSize: 16)),
                       const SizedBox(height: 4),
                      Text(subLabel, style: GoogleFonts.muktaVaani(color: Colors.grey, fontSize: 12)),
                  ],
              ),
          ),
      );
  }
}
