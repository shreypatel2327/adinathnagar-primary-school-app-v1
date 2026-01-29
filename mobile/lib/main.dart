import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/screens/add_student_screen.dart';
import 'package:mobile/screens/dashboard_screen.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/splash_screen.dart';
import 'package:mobile/screens/student_detail_screen.dart';
import 'package:mobile/screens/student_list_screen.dart';
import 'package:mobile/screens/certificates/bonafide_screen.dart';
import 'package:mobile/screens/certificates/vali_form_screen.dart';
import 'package:mobile/screens/javak_register_screen.dart';
import 'package:mobile/screens/aavak_register_screen.dart';
import 'package:mobile/screens/teacher_list_screen.dart';
import 'package:mobile/screens/add_edit_teacher_screen.dart';
import 'package:mobile/screens/system_logs_screen.dart';
import 'package:mobile/screens/teacher_dashboard_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/students',
      builder: (context, state) {
        final search = state.uri.queryParameters['search'];
        final lockedStandard = state.uri.queryParameters['lockedStandard'];
        return StudentListScreen(
            initialSearch: search,
            lockedStandard: lockedStandard != null ? int.tryParse(lockedStandard) : null
        );
      },
    ),
    GoRoute(
      path: '/students/add',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return AddStudentScreen(lockedStandard: extra?['lockedStandard']);
      },
    ),
    GoRoute(
      path: '/students/detail/:id',
      builder: (context, state) => StudentDetailScreen(studentId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/students/edit/:id',
      builder: (context, state) {
        final student = state.extra as Map<String, dynamic>?;
        return AddStudentScreen(studentId: state.pathParameters['id'], studentData: student);
      },
    ),
    GoRoute(
      path: '/students/certificate/bonafide/:id',
      builder: (context, state) {
        final student = state.extra as Map<String, dynamic>;
        return BonafideCertificateScreen(student: student);
      },
    ),
    GoRoute(
      path: '/students/certificate/vali/:id',
      builder: (context, state) {
        final student = state.extra as Map<String, dynamic>;
        return ValiFormScreen(student: student);
      },
    ),
    GoRoute(
      path: '/javak-register',
      builder: (context, state) => const JavakRegisterScreen(),
    ),
    GoRoute(
      path: '/aavak-register',
      builder: (context, state) => const AavakRegisterScreen(),
    ),
    GoRoute(
      path: '/teachers',
      builder: (context, state) => const TeacherListScreen(),
    ),
    GoRoute(
      path: '/teachers/add',
      builder: (context, state) => const AddEditTeacherScreen(),
    ),
    GoRoute(
      path: '/teachers/edit/:id',
      builder: (context, state) {
        final teacher = state.extra as Map<String, dynamic>;
        return AddEditTeacherScreen(teacherId: state.pathParameters['id'], teacherData: teacher);
      },
    ),
    GoRoute(
      path: '/system-logs',
      builder: (context, state) => const SystemLogsScreen(),
    ),
    GoRoute(
      path: '/teacher-dashboard',
      builder: (context, state) => const TeacherDashboardScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'School App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2B8CEE),
          primary: const Color(0xFF2B8CEE),
          surface: Colors.white,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.muktaVaaniTextTheme(),
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
