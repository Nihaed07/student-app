import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/models/models.dart';

class StudentProvider extends ChangeNotifier {
  List<StudentModel> _students = [];
  bool _darkMode = true;
  String? _currentUser;
  Map<String, String> _users = {};

  List<StudentModel> get students => _students;
  bool get darkMode => _darkMode;
  String? get currentUser => _currentUser;

  StudentProvider() {
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    await _loadUsers();
    await _loadStudents();
    await _loadSettings();
    notifyListeners();
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users');
    if (usersJson != null) {
      _users = Map<String, String>.from(jsonDecode(usersJson));
    }
  }

  Future<bool> registerUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (_users.containsKey(email)) {
      return false; 
    }
    
    _users[email] = password;
    await prefs.setString('users', jsonEncode(_users));
    
    _currentUser = email;
    await prefs.setString('currentUser', email);
    
    notifyListeners();
    return true;
  }

  Future<bool> loginUser(String email, String password) async {
    await _loadUsers();
    
    if (_users[email] == password) {
      final prefs = await SharedPreferences.getInstance();
      _currentUser = email;
      await prefs.setString('currentUser', email);
      
      await _loadStudents();
      await _loadSettings();
      
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUser = null;
    await prefs.remove('currentUser');
    _students.clear();
    notifyListeners();
  }

  Future<void> _loadStudents() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUser == null) return;
    
    final studentsJson = prefs.getString('students_${_currentUser}');
    
    if (studentsJson != null) {
      final List<dynamic> studentsList = jsonDecode(studentsJson);
      _students = studentsList
          .map((studentJson) => StudentModel.fromJson(studentJson))
          .toList();
    }
  }

  Future<void> saveStudents() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUser == null) return;
    
    final studentsJson = jsonEncode(
      _students.map((student) => student.toJson()).toList()
    );
    await prefs.setString('students_${_currentUser}', studentsJson);
  }

  Future<void> addStudent(StudentModel student) async {
    // Check if student with same ID already exists
    if (_students.any((s) => s.id == student.id)) {
      throw Exception('Student with ID ${student.id} already exists');
    }
    
    _students.add(student);
    await saveStudents();
    notifyListeners();
  }

  Future<void> updateStudent(String id, StudentModel updatedStudent) async {
    final index = _students.indexWhere((student) => student.id == id);
    if (index != -1) {
      _students[index] = updatedStudent;
      await saveStudents();
      notifyListeners();
    }
  }

  Future<void> deleteStudent(String id) async {
    _students.removeWhere((student) => student.id == id);
    await saveStudents();
    notifyListeners();
  }

  Future<void> toggleAttendance(String id, DateTime date, bool isPresent) async {
    final index = _students.indexWhere((student) => student.id == id);
    if (index != -1) {
      final student = _students[index];
      final dateKey = '${date.year}-${date.month}-${date.day}';
      
      final updatedAttendance = Map<String, bool>.from(student.attendanceHistory);
      updatedAttendance[dateKey] = isPresent;
      
      _students[index] = student.copyWith(
        attendanceHistory: updatedAttendance,
        isPresent: isPresent,
      );
      
      await saveStudents();
      notifyListeners();
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUser == null) return;
    
    _darkMode = prefs.getBool('darkMode_${_currentUser}') ?? true;
  }

  Future<void> toggleDarkMode(bool value) async {
    _darkMode = value;
    final prefs = await SharedPreferences.getInstance();
    if (_currentUser != null) {
      await prefs.setBool('darkMode_${_currentUser}', value);
    }
    notifyListeners();
  }

  Map<String, dynamic> getMonthlyReport(String month, String year) {
    final report = <String, Map<String, dynamic>>{};
    
    for (final student in _students) {
      int presentDays = 0;
      int totalDays = 0;
      
      for (final entry in student.attendanceHistory.entries) {
        final dateParts = entry.key.split('-');
        if (dateParts[0] == year && 
            dateParts[1] == month) {
          totalDays++;
          if (entry.value) presentDays++;
        }
      }
      
      final percentage = totalDays > 0 ? (presentDays / totalDays * 100).round() : 0;
      
      report[student.id] = {
        'student': student,
        'present': presentDays,
        'absent': totalDays - presentDays,
        'total': totalDays,
        'percentage': percentage,
      };
    }
    
    return report;
  }

  // Search functionality
  List<StudentModel> searchStudents(String query) {
    if (query.isEmpty) return _students;
    
    final lowerQuery = query.toLowerCase();
    return _students.where((student) {
      return student.name.toLowerCase().contains(lowerQuery) ||
             student.id.toLowerCase().contains(lowerQuery) ||
             student.std.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _students.clear();
    _users.clear();
    _currentUser = null;
    notifyListeners();
  }
}