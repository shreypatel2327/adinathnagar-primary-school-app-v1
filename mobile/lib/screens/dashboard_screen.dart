import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic> _stats = {
    'totalStudents': '...',
    'standardCount': '1-8',
    'aavakCount': '...',
    'javakCount': '...'
  };
  
  @override
  void initState() {
    super.initState();
    _fetchStats();
  }
  
  Future<void> _fetchStats() async {
      try {
          final data = await _apiService.getDashboardStats();
          if (mounted) {
              setState(() {
                  _stats = {
                      'totalStudents': data['totalStudents'].toString(),
                      'standardCount': data['standardCount'].toString(),
                      'aavakCount': data['aavakCount'].toString(), 
                      'javakCount': data['javakCount'].toString()
                  };
              });
          }
      } catch (e) {
          // Keep defaults
          print("Error fetching stats: $e");
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[200]!),
                image: const DecorationImage(
                  image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAGGwQl1JGjyZECDJZab8DbjZpxrOs2LRuo83buYz0ZiqZHQWAg6qTp5E8ZQbUx2M4LiIN-Ygb0PQtKThovotGGWr2AqYJfIodKaQ18p-M9BmLkSOmFAVcRt_EJoEkgs9yNEOERS6tnxpKVyNEi3nolXS1IwSbMp1ws_WaN2mA7YbrJ0L2ZMNTUYfteifE8r2-BHpE7CryhpNp0ERiZ-RQ30NEAKhQdqGIQzuyA_YkjzEAzqAgRJyUobR8REZmxAg4JFun539Ns4oM'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'આદિનાથનગર પ્રાથમિક શાળા',
                  style: GoogleFonts.notoSansGujarati(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111418),
                  ),
                ),
                Text(
                  'આચાર્ય ડેશબોર્ડ',
                  style: GoogleFonts.notoSansGujarati(
                    fontSize: 12,
                    color: const Color(0xFF617589),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF111418)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
                // Logout Logic
                context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          children: [
            // Search Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: TextField(
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                    if (value.isNotEmpty) {
                        context.push('/students?search=$value');
                    }
                },
                decoration: InputDecoration(
                  hintText: 'નામ, GR નં, અથવા મોબાઇલ દ્વારા શોધો...',
                  hintStyle: GoogleFonts.notoSansGujarati(color: const Color(0xFF617589)),
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
            ),
            
            // Stats Grid
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard(
                    icon: Icons.groups,
                    iconColor: const Color(0xFF2B8CEE),
                    label: 'કુલ વિદ્યાર્થી',
                    value: _stats['totalStudents'],
                  ),
                  _buildStatCard(
                    icon: Icons.school,
                    iconColor: Colors.orange,
                    label: 'ધોરણવાર',
                    value: _stats['standardCount'],
                  ),
                  _buildStatCard(
                    icon: Icons.move_to_inbox,
                    iconColor: Colors.green,
                    label: 'આવક',
                    value: _stats['aavakCount'],
                  ),
                  _buildStatCard(
                    icon: Icons.outbox,
                    iconColor: Colors.red,
                    label: 'જાવક',
                    value: _stats['javakCount'],
                  ),
                ],
              ),
            ),
            
            // Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ઝડપી કાર્યો',
                    style: GoogleFonts.notoSansGujarati(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111418),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    context,
                    icon: Icons.person_add,
                    color: const Color(0xFF2B8CEE),
                    title: 'નવો વિદ્યાર્થી',
                    subtitle: 'પ્રવેશ ફોર્મ ભરો',
                    onTap: () => context.push('/students/add'),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    context,
                    icon: Icons.verified,
                    color: Colors.purple,
                    title: 'બોનાફાઇડ',
                    subtitle: 'બોનાફાઇડ સર્ટિફિકેટ જનરેટ કરો',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    context,
                    icon: Icons.menu_book,
                    color: Colors.teal,
                    title: 'પત્રકો',
                    subtitle: 'હાજરી અને અન્ય પત્રકો',
                    onTap: () => context.push('/students'),
                  ),
                   const SizedBox(height: 12),
                   _buildActionCard(
                     context,
                     icon: Icons.person_off,
                     color: Colors.redAccent,
                     title: 'જાવક રજીસ્ટર',
                     subtitle: 'કમી કરેલ વિદ્યાર્થીઓ',
                     onTap: () => context.push('/javak-register'),
                   ),
                   const SizedBox(height: 12),
                   _buildActionCard(
                     context,
                     icon: Icons.person_add_alt_1, 
                     color: Colors.green,
                     title: 'આવક રજીસ્ટર',
                     subtitle: 'તમામ દાખલ વિદ્યાર્થીઓ',
                     onTap: () => context.push('/aavak-register'),
                   ),
                ],
              ),
            ),
             
             // Recent Activity
             Padding(
               padding: const EdgeInsets.all(16),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(
                        'તાજેતરની પ્રવૃત્તિ',
                        style: GoogleFonts.notoSansGujarati(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF111418),
                        ),
                      ),
                       TextButton(
                         onPressed: () => context.push('/system-logs'),
                         child: Text(
                           'બધું જુઓ',
                           style: GoogleFonts.notoSansGujarati(
                             color: const Color(0xFF2B8CEE),
                             fontWeight: FontWeight.w500,
                           ),
                         ),
                       ),
                     ],
                   ),
                   _buildActivityItem(
                     icon: Container(
                       width: 32,
                       height: 32,
                       alignment: Alignment.center,
                       decoration: BoxDecoration(
                         color: Colors.green[100],
                         shape: BoxShape.circle,
                       ),
                       child: const Text('NR', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                     ),
                     title: 'ધોરણ 3 માં નવો પ્રવેશ',
                     subtitle: 'વિદ્યાર્થી: રાહુલ પરમાર',
                     time: '2 કલાક પહેલા',
                   ),
                   _buildActivityItem(
                     icon: const Icon(Icons.event_available, color: Colors.blue),
                     iconBg: Colors.blue[100]!,
                     title: 'રજા મંજૂર',
                     subtitle: 'શિક્ષક: રમેશભાઈ પટેલ',
                     time: 'ગઈકાલે',
                   ),
                 ],
               ),
             ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2B8CEE),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.notoSansGujarati(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.notoSansGujarati(fontSize: 12, fontWeight: FontWeight.w500),
        onTap: (index) {
          if (index == 1) context.push('/students'); // Students tab
          if (index == 2) context.push('/teachers'); // Staff tab
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'મુખ્ય'),
          BottomNavigationBarItem(icon: Icon(Icons.backpack), label: 'વિદ્યાર્થીઓ'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'સ્ટાફ'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'સેટિંગ્સ'),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.notoSansGujarati(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF111418),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.publicSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111418),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.notoSansGujarati(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111418),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.notoSansGujarati(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActivityItem({
    required Widget icon,
    Color? iconBg,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           if (icon is Icon)
             Container(
               padding: const EdgeInsets.all(6),
               decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
               child: icon,
             )
           else
             icon,
           const SizedBox(width: 12),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(title, style: GoogleFonts.notoSansGujarati(fontWeight: FontWeight.w500)),
                 Text(subtitle, style: GoogleFonts.notoSansGujarati(fontSize: 12, color: Colors.grey)),
               ],
             ),
           ),
           Text(time, style: GoogleFonts.notoSansGujarati(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}
