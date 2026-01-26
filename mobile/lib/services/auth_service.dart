import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/services/api_service.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  Map<String, dynamic>? _currentUser;
  String? _token;

  bool get isLoggedIn => _token != null;
  Map<String, dynamic>? get currentUser => _currentUser;
  
  // Helpers
  bool get isAdmin => _currentUser?['role'] == 'ADMIN';
  bool get isTeacher => _currentUser?['role'] == 'TEACHER';
  int? get assignedStandard => _currentUser?['standard'] != null ? int.tryParse(_currentUser!['standard'].toString()) : null;

  Map<String, String> get headers {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    final userStr = prefs.getString('auth_user');
    if (userStr != null) {
        _currentUser = json.decode(userStr);
    }
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['token'];
        _currentUser = data['user'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('auth_user', json.encode(_currentUser));
      } else {
        throw Exception(json.decode(response.body)['error'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_user');
  }
}
