import 'package:supabase_flutter/supabase_flutter.dart';

class Employer {
  final String employerId;
  final String userId;
  final String companyName;
  final String? companyLogo;
  final String? companyEmail;
  final String? companyPhone;
  final String? companyDescription;
  final String? companyAddress;
  final String? companyWebsite;
  final String companyVerificationStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Employer({
    required this.employerId,
    required this.userId,
    required this.companyName,
    this.companyLogo,
    this.companyEmail,
    this.companyPhone,
    this.companyDescription,
    this.companyAddress,
    this.companyWebsite,
    required this.companyVerificationStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory Employer.fromJson(Map<String, dynamic> json) {
    return Employer(
      employerId: json['employerID']?.toString() ?? json['employerId']?.toString() ?? '',
      userId: json['userID']?.toString() ?? json['userId']?.toString() ?? '',
      companyName: json['companyName']?.toString() ?? '',
      companyLogo: json['companyLogo']?.toString(),
      companyEmail: json['companyEmail']?.toString(),
      companyPhone: json['companyPhone']?.toString(),
      companyDescription: json['companyDescription']?.toString(),
      companyAddress: json['companyAddress']?.toString(),
      companyWebsite: json['companyWebsite']?.toString(),
      companyVerificationStatus: json['companyVerificationStatus']?.toString() ?? 'Pending',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employerID': employerId,
      'userID': userId,
      'companyName': companyName,
      'companyLogo': companyLogo,
      'companyEmail': companyEmail,
      'companyPhone': companyPhone,
      'companyDescription': companyDescription,
      'companyAddress': companyAddress,
      'companyWebsite': companyWebsite,
      'companyVerificationStatus': companyVerificationStatus,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static final _supabase = Supabase.instance.client;

  static Future<Employer?> fetchByUserId(String userId) async {
    try {
      final response = await _supabase
          .from('employers')
          .select()
          .eq('userID', userId)
          .maybeSingle();
      return response != null ? Employer.fromJson(response) : null;
    } catch (e) {
      print('Error fetching employer: $e');
      return null;
    }
  }

  static Future<void> createEmployer(Employer employer) async {
    try {
      await _supabase.from('employers').insert(employer.toJson());
    } catch (e) {
      print('Error creating employer: $e');
      rethrow;
    }
  }

  static Future<void> updateEmployer(Employer employer) async {
    try {
      await _supabase
          .from('employers')
          .update(employer.toJson())
          .eq('employerID', employer.employerId);
    } catch (e) {
      print('Error updating employer: $e');
      rethrow;
    }
  }
}
