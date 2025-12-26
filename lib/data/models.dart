import 'dart:convert';
import 'package:flutter/foundation.dart';

class StudentModel {
  final String? studentImage;
  final String name;
  final String id;
  final String phoneNumber;
  final String place;
  final String std;
  final String dob;
  final bool isPresent;
  final Map<String, bool> attendanceHistory;

  StudentModel({
    this.studentImage,
    required this.name,
    required this.id,
    required this.phoneNumber,
    required this.place,
    required this.std,
    required this.dob,
    this.isPresent = false,
    this.attendanceHistory = const {},
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentImage: json['studentImage'],
      name: json['name'],
      id: json['id'],
      phoneNumber: json['phoneNumber'] ?? '',
      place: json['place'] ?? '',
      std: json['std'] ?? '',
      dob: json['dob'] ?? '',
      isPresent: json['isPresent'] ?? false,
      attendanceHistory: Map<String, bool>.from(
        json['attendanceHistory'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentImage': studentImage,
      'name': name,
      'id': id,
      'phoneNumber': phoneNumber,
      'place': place,
      'std': std,
      'dob': dob,
      'isPresent': isPresent,
      'attendanceHistory': attendanceHistory,
    };
  }

  StudentModel copyWith({
    String? studentImage,
    String? name,
    String? id,
    String? phoneNumber,
    String? place,
    String? std,
    String? dob,
    bool? isPresent,
    Map<String, bool>? attendanceHistory,
  }) {
    return StudentModel(
      studentImage: studentImage ?? this.studentImage,
      name: name ?? this.name,
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      place: place ?? this.place,
      std: std ?? this.std,
      dob: dob ?? this.dob,
      isPresent: isPresent ?? this.isPresent,
      attendanceHistory: attendanceHistory ?? this.attendanceHistory,
    );
  }

  @override
  String toString() {
    return 'StudentModel(name: $name, id: $id, std: $std, isPresent: $isPresent)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is StudentModel &&
      other.studentImage == studentImage &&
      other.name == name &&
      other.id == id &&
      other.phoneNumber == phoneNumber &&
      other.place == place &&
      other.std == std &&
      other.dob == dob &&
      other.isPresent == isPresent &&
      mapEquals(other.attendanceHistory, attendanceHistory);
  }

  @override
  int get hashCode {
    return studentImage.hashCode ^
      name.hashCode ^
      id.hashCode ^
      phoneNumber.hashCode ^
      place.hashCode ^
      std.hashCode ^
      dob.hashCode ^
      isPresent.hashCode ^
      attendanceHistory.hashCode;
  }
}