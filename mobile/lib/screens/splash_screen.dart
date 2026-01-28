import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      await AuthService().loadUser();
      if (mounted) {
        if (AuthService().isLoggedIn) {
             if (AuthService().isTeacher) {
                  context.go('/teacher-dashboard');
              } else {
                  context.go('/dashboard');
              }
        } else {
          context.go('/login');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF6F7F8)],
          ),
        ),
        child: Stack(
          children: [
            // Decorative Background Circles
            Positioned(
              top: -128,
              right: -128,
              child: Container(
                width: 384,
                height: 384,
                decoration: BoxDecoration(
                  color: const Color(0xFF2B8CEE).withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            // Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                   Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2B8CEE).withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 72,
                      color: Color(0xFF2B8CEE),
                    ),
                  ),
                  
                  // Title
                  Text(
                    'આદિનાથનગર \nપ્રાથમિક શાળા',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.muktaVaani(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111418),
                      height: 1.2,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Subtitle
                  Text(
                    'SCHOOL MANAGEMENT APP',
                    style: GoogleFonts.muktaVaani(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                      color: const Color(0xFF2B8CEE),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Loading Indicator
                  SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2B8CEE)),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
            
            // Footer
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBv_qcP3WV3L4knnlveuQfvQi_kjA7mZ1M99xMdsXw5TOPUgdWR-IvQDN4LF-rnMkCq0OLAl2q4ORyc_hV0eYhoHFnuS-i44ldksDhtj1cHToIGMyOrwHnQeWAWjE8C4EkftigfWx0vgWwRFiYkuh-Yu0tEAGU2UiJbtjVIWoONnUbW0yV-Eus1758AzSKlUkAIZsAyJMsII0U-JxDvi7YdiW-86z3Zzinjqf0t1IGQOKllw8XLvJeulPeahqYCmwkgCTBJ0LwQYx8',
                    height: 64,
                    width: 64,
                     color: Colors.black.withOpacity(0.9),
                     colorBlendMode: BlendMode.saturation,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'GOVERNMENT OF GUJARAT',
                    style: GoogleFonts.muktaVaani(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: const Color(0xFF111418),
                    ),
                  ),
                  Text(
                    'Education Department',
                    style: GoogleFonts.muktaVaani(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF617589),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'v1.0.0',
                    style: GoogleFonts.muktaVaani(
                      fontSize: 10,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
