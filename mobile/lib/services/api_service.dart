import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:io';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/api';
    } else {
      return 'http://localhost:3000/api';
    }
  }

  Future<List<dynamic>> getStudents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/students'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load students');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<void> createStudent(Map<String, dynamic> studentData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/students'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(studentData),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to create student: ${response.body}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<Map<String, dynamic>> getStudentById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/students/$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load student details');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<void> updateStudent(String id, Map<String, dynamic> studentData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/students/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(studentData),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update student: ${response.body}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<void> deleteStudent(String id) async {
     try {
      final response = await http.delete(Uri.parse('$baseUrl/students/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete student');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<void> markStudentAsJavak(String id, String destinationSchool, DateTime leavingDate, String remarks) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/students/$id/javak'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'destinationSchool': destinationSchool,
          'leavingDate': leavingDate.toIso8601String(),
          'remarks': remarks,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to mark student as Javak: ${response.body}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<List<dynamic>> getJavakStudents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/javak-register'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load Javak register: ${response.body}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<List<dynamic>> getAavakStudents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/aavak-register'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load Aavak register: ${response.body}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/dashboard/stats'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load dashboard stats: ${response.body}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  // Teachers
  Future<List<dynamic>> getTeachers({String? search}) async {
    try {
      String url = '$baseUrl/teachers';
      if (search != null && search.isNotEmpty) {
          url += '?search=$search';
      }
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load teachers: ${response.body}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<void> createTeacher(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/teachers'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to create teacher: ${response.body}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<void> updateTeacher(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/teachers/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update teacher: ${response.body}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}

