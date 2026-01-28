import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
            // Decorative Blobs
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: const Color(0xFF2B8CEE).withOpacity(0.05),
                  shape: BoxShape.circle,
                  
                ),
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(),
                ),
              ),
            ),
             Positioned(
              bottom: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: const Color(0xFF2B8CEE).withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            Center(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                             // Logo
                            Container(
                                width: 96,
                                height: 96,
                                margin: const EdgeInsets.only(bottom: 24),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey[100]!),
                                    image: const DecorationImage(
                                        image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuC-EAeR0cZQZjQpqrdyuG3hW5I8yUx9-CPQC4Xat8AVTZMIpCSpJvr1jaXeWqpow6AV3yQ-uuj1xHIF7cPVim3Tzq0Hsooc1eCiNshz4KsVC206avOxd8ftRJVwRjbe-R2Az7vKJ9kAdPKuwP6OoaW_Nof7NMxoreY1ehC9afZzAB4QdaFRVmQIn0md2ZqEs4hec5Q2MaUBhe6G_PuKijNpdDPI-4cQMkG_vyKQZJyNKAcOoZMb48hQhVn2cYb6jyQB4g4-tEMnomE'),
                                        fit: BoxFit.cover,
                                    ),
                                ),
                            ),
                            
                            // Title
                            Text(
                                'શ્રી સરકારી પ્રાથમિક શાળા',
                                style: GoogleFonts.muktaVaani(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF111418),
                                ),
                                textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 32),
                            
                            Form(
                                key: _formKey,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                            'વપરાશકર્તા નામ',
                                            style: GoogleFonts.muktaVaani(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF111418),
                                            ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                            controller: _usernameController,
                                            validator: (val) => val!.isEmpty ? 'Username required' : null,
                                            decoration: InputDecoration(
                                                hintText: 'Enter username',
                                                suffixIcon: const Icon(Icons.person_outline, color: Color(0xFF617589)),
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                    borderSide: const BorderSide(color: Color(0xFFDBE0E6)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                    borderSide: const BorderSide(color: Color(0xFFDBE0E6)),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding: const EdgeInsets.all(16),
                                            ),
                                        ),
                                        
                                        const SizedBox(height: 20),
                                        
                                        Text(
                                            'પાસવર્ડ',
                                            style: GoogleFonts.muktaVaani(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF111418),
                                            ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                            controller: _passwordController,
                                            validator: (val) => val!.isEmpty ? 'Password required' : null,
                                            obscureText: _obscurePassword,
                                            decoration: InputDecoration(
                                                hintText: 'Enter password',
                                                suffixIcon: IconButton(
                                                    icon: Icon(
                                                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                                        color: const Color(0xFF617589),
                                                    ),
                                                    onPressed: () {
                                                        setState(() {
                                                            _obscurePassword = !_obscurePassword;
                                                        });
                                                    },
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                    borderSide: const BorderSide(color: Color(0xFFDBE0E6)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                    borderSide: const BorderSide(color: Color(0xFFDBE0E6)),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding: const EdgeInsets.all(16),
                                            ),
                                        ),
                                        
                                        const SizedBox(height: 24),
                                        
                                            // Login Logic
                                            SizedBox(
                                                width: double.infinity,
                                                height: 48,
                                                child: ElevatedButton(
                                                    onPressed: _isLoading ? null : _login,
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor: const Color(0xFF2B8CEE),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        elevation: 2,
                                                    ),
                                                    child: _isLoading 
                                                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                                        : Text(
                                                            'લોગિન',
                                                            style: GoogleFonts.muktaVaani(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                            ),
                                                        ),
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                            
                            const SizedBox(height: 48),
                            
                            Text(
                                'v1.0 • સહાયતા',
                                style: GoogleFonts.muktaVaani(
                                    color: const Color(0xFF617589),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                ),
                            ),
                        ],
                    ),
                ),
            ),
        ],
      ),
    );
  }

  void _login() async {
      if (_formKey.currentState!.validate()) {
          setState(() => _isLoading = true);
          try {
              await AuthService().login(_usernameController.text, _passwordController.text);
              if (mounted) {
                  if (AuthService().isTeacher) {
                      context.go('/teacher-dashboard');
                  } else {
                      context.go('/dashboard');
                  }
              }
          } catch (e) {
              if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')))
                  );
              }
          } finally {
              if (mounted) setState(() => _isLoading = false);
          }
      }
  }
}
